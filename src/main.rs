// Prevent console window in addition to Slint window in Windows release builds when, e.g., starting the app via file manager. Ignored on other platforms.
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::{
    error::Error,
    fmt::Display,
    fs::OpenOptions,
    io::{BufReader, BufWriter, Read, Write},
    path::PathBuf,
    sync::{Arc, Mutex},
    thread,
    time::Duration,
};

use derive_typst_intoval::{IntoDict, IntoValue};
use include_dir::{Dir, include_dir};
use rayon::iter::{IntoParallelRefIterator, ParallelIterator};
use rfd::AsyncFileDialog;
use slint::{Model, ModelRc, SharedString, VecModel, spawn_local};
use typst::{
    diag::SourceDiagnostic,
    ecow::EcoVec,
    foundations::{Bytes, Dict, IntoValue},
};
use typst_as_lib::{TypstEngine, TypstTemplateMainFile};

static TEMPLATES: Dir = include_dir!("$CARGO_MANIFEST_DIR/templates/");

#[derive(Debug, Clone, PartialEq, Eq)]
struct StringError(String);
impl Display for StringError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}
impl Error for StringError {}

#[derive(Debug, Clone, IntoDict)]
struct TemplateInput {
    input_json: Bytes,
    production: bool,
    args: Dict,
}

#[derive(Debug, Clone, IntoValue, IntoDict)]
struct GleneaglesTemplateArgs {
    show_gleneagles_logo: bool,
}

#[derive(Debug, Clone, IntoValue, IntoDict)]
struct PlatinumTemplateArgs {

}

#[derive(Debug, Clone, Hash, PartialEq)]
struct TypstPdfGenerationError(EcoVec<SourceDiagnostic>);
impl Display for TypstPdfGenerationError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{:?}", self.0)
    }
}
impl Error for TypstPdfGenerationError {}

slint::include_modules!();

fn templates() -> &'static [&'static str] {
    &[
        "Gleneagles_ENG",
        "Gleneagles_ENG (white label)",
        "Gleneagles_CN",
        "Gleneagles_CN (white label)",
        "Platinum_ENG",
    ]
}

fn build_engine(name: impl AsRef<str>) -> anyhow::Result<TypstEngine<TypstTemplateMainFile>> {
    let name = name.as_ref();
    let template_dir = TEMPLATES.get_dir(name).unwrap();
    let fonts = template_dir
        .find(&format!("{name}/**/*.ttf"))?
        .chain(template_dir.find(&format!("{name}/**/*.ttc"))?);
    let source_files = template_dir.find(&format!("{name}/**/*.typ"))?;
    let other_files = template_dir
        .find(&format!("{name}/**/*.png"))?
        .chain(template_dir.find(&format!("{name}/**/*.jpg"))?)
        .chain(template_dir.find(&format!("{name}/**/*.json"))?)
        .chain(template_dir.find(&format!("{name}/**/*.svg"))?)
        .chain(template_dir.find(&format!("{name}/**/*.yml"))?)
        .chain(template_dir.find(&format!("{name}/**/*.yaml"))?);
    Ok(TypstEngine::builder()
        .main_file(
            template_dir
                .get_file(format!("{name}/{name}.typ"))
                .unwrap()
                .contents_utf8()
                .unwrap(),
        )
        .with_static_source_file_resolver(source_files.map(|src| {
            (
                {
                    let mut p = src.path().components();
                    p.next();
                    p
                }
                .as_path()
                .to_str()
                .unwrap(),
                src.as_file().unwrap().contents_utf8().unwrap(),
            )
        }))
        .with_static_file_resolver(other_files.map(|src| {
            (
                {
                    let mut p = src.path().components();
                    p.next();
                    p
                }
                .as_path()
                .to_str()
                .unwrap(),
                src.as_file().unwrap().contents(),
            )
        }))
        .with_package_file_resolver()
        .fonts(fonts.map(|font| font.as_file().unwrap().contents()))
        .build())
}

fn compile(
    input: &String,
    selected_template: impl AsRef<str>,
    args: Dict,
    template_display_name: impl AsRef<str>,
) -> anyhow::Result<()> {
    let selected_template = selected_template.as_ref();
    let template_display_name = template_display_name.as_ref();
    println!("Reading input json from: {input}");
    let mut reader = BufReader::new(OpenOptions::new().read(true).open(input)?);
    let mut input_json = Vec::new();
    reader.read_to_end(&mut input_json)?;
    let input_json = Bytes::new(input_json);
    let template_input = TemplateInput {
        input_json,
        args,
        production: true,
    };
    println!("Compiling template: {template_display_name} ({selected_template})");
    match build_engine(&selected_template)?
        .compile_with_input(template_input.into_dict())
        .output
    {
        Ok(doc) => {
            print!("Successfully compiled input {input}. ");
            match typst_pdf::pdf(&doc, &Default::default()) {
                Ok(pdf) => {
                    let input_pathbuf = PathBuf::from(input);
                    let sample_id = input_pathbuf
                        .file_name()
                        .unwrap()
                        .to_str()
                        .unwrap()
                        .split("_")
                        .nth(0)
                        .unwrap();
                    let output_pathbuf = PathBuf::from(input);
                    let output_filename = format!("{sample_id}_{template_display_name}.pdf");
                    let output_filepath = output_pathbuf.parent().unwrap().join(&output_filename);
                    println!("Writing output PDF to {output_filename}");
                    let mut writer = BufWriter::new(
                        OpenOptions::new()
                            .read(true)
                            .write(true)
                            .create(true)
                            .open(output_filepath)?,
                    );
                    writer.write(&pdf)?;
                    writer.flush()?;
                    println!("Successful!")
                }
                Err(err) => {
                    eprintln!("Error while generating output PDF:\n{:?}", err);
                    Err(TypstPdfGenerationError(err))?;
                }
            }
        }
        Err(err) => {
            eprintln!("Error while compiling template:\n{}", err);
            Err(err)?;
        }
    }
    Ok(())
}

fn main() -> anyhow::Result<()> {
    let app = AppWindow::new()?;
    app.set_templates(ModelRc::new(VecModel::from_iter(
        templates().into_iter().map(|template| SelectItem {
            label: SharedString::from(*template),
            value: SharedString::from(*template),
        }),
    )));
    app.on_select_inputs({
        let app = app.clone_strong();
        move || {
            _ = spawn_local({
                let app = app.clone_strong();
                async move {
                    if let Some(mut files) = AsyncFileDialog::new()
                        .add_filter("Report Input", &["json"])
                        .pick_files()
                        .await
                    {
                        files.sort_by_key(|file| file.file_name());
                        app.set_inputs(ModelRc::new(VecModel::from_iter(files.iter().map(
                            |file| {
                                Input {
                                    name: SharedString::from(
                                        file.path()
                                            .components()
                                            .next_back()
                                            .unwrap()
                                            .as_os_str()
                                            .to_str()
                                            .unwrap(),
                                    ),
                                    path: SharedString::from(file.path().to_str().unwrap()),
                                }
                            },
                        ))));
                    }
                }
            })
            .inspect_err(|e| eprintln!("Could not select file: {e}"));
        }
    });
    app.on_clear_inputs({
        let app = app.clone_strong();
        move || app.set_inputs(ModelRc::new(VecModel::from_iter([])))
    });
    let generate_res = Arc::new(Mutex::new(None as Option<Result<(), String>>));
    app.on_generate({
        let generate_res = generate_res.clone();
        let app = app.clone_strong();
        move |inputs, template_index| {
            app.set_is_generating(true);
            let inputs = inputs
                .iter()
                .map(|input| input.path.as_str().to_string())
                .collect::<Vec<_>>();
            let template_display_name = templates()[template_index as usize];
            println!("Inputs: {inputs:?}, selected template: {template_display_name}");
            thread::spawn({
                let generate_res = generate_res.clone();
                move || {
                    let res = inputs
                        .par_iter()
                        .map(|input| match template_display_name {
                            "Gleneagles_ENG" => compile(
                                input,
                                "Gleneagles_ENG",
                                GleneaglesTemplateArgs {
                                    show_gleneagles_logo: true,
                                }
                                .into_dict(),
                                template_display_name,
                            ),
                            "Gleneagles_ENG (white label)" => compile(
                                input,
                                "Gleneagles_ENG",
                                GleneaglesTemplateArgs {
                                    show_gleneagles_logo: false,
                                }
                                .into_dict(),
                                template_display_name,
                            ),
                            "Gleneagles_CN" => compile(
                                input,
                                "Gleneagles_CN",
                                GleneaglesTemplateArgs {
                                    show_gleneagles_logo: true,
                                }
                                .into_dict(),
                                template_display_name,
                            ),
                            "Gleneagles_CN (white label)" => compile(
                                input,
                                "Gleneagles_CN",
                                GleneaglesTemplateArgs {
                                    show_gleneagles_logo: false,
                                }
                                .into_dict(),
                                template_display_name,
                            ),
                            "Platinum_ENG" => compile(
                                input,
                                "Platinum_ENG",
                                PlatinumTemplateArgs {
                                    
                                }
                                .into_dict(),
                                template_display_name
                            ),
                            _ => anyhow::Result::Err(anyhow::Error::new(StringError(
                                "Template not implemented".to_string(),
                            ))),
                        })
                        .find_any(|res| res.is_err());
                    *generate_res.lock().unwrap() = Some(if let Some(Err(err)) = res {
                        Err(err.to_string())
                    } else {
                        Ok(())
                    });
                }
            });
            let generate_res = generate_res.clone();
            let app = app.clone_strong();
            _ = spawn_local(async_compat::Compat::new(async move {
                for _ in 0..400 {
                    if let Some(res) = generate_res.lock().unwrap().as_ref() {
                        match res {
                            Ok(_) => {
                                app.set_show_success(true);
                                tokio::time::sleep(Duration::from_secs(1)).await;
                                app.set_show_success(false);
                            }
                            Err(_) => {
                                app.set_show_failure(true);
                                tokio::time::sleep(Duration::from_secs(1)).await;
                                app.set_show_failure(false);
                            }
                        }
                        break;
                    }
                    tokio::time::sleep(Duration::from_millis(100)).await;
                }
                *generate_res.lock().unwrap() = None;
                app.set_is_generating(false);
            }));
        }
    });
    app.run()?;
    Ok(())
}
