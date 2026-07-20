#import "../lib.typ": *
#import "@preview/shadowed:0.3.0": shadow

#let producers-card(label: [], tagline: [], producers: (), increases: (), producers-increases-spacing: 1.5cm, arrow-scale: 100%) = box(width: 33%, stack(
  shadow(
    blur: 8pt,
    dx: 0.5em,
    dy: 0.5em,
    fill: gray.lighten(10%).transparentize(50%),
    rect(
      width: 100%,
      fill: rgb("f9f9f9"),
      inset: (top: 1em, x: 1em, bottom: 1.3em),
      stack(
        spacing: 0.7em,
        align(center, rect(
          inset: 7pt,
          width: 93%,
          fill: primary-container.lighten(20%),
          radius: 50%,
          {
            text(size: 12pt, fill: primary)[*#label*]
          },
        )),
        pad(x: 1em, align(center, par(leading: 0.5em, text(size: 9pt, fill: primary)[*#tagline*]))),
        align(left, {
          set par(leading: 0.6em)
          set text(size: 10pt)
          for comment in producers {
            [- _#comment _]
          }
        }),
        place(center + top, dy: 0cm, scale(arrow-scale, reflow: true, image("images/arrow-down.png"))),
      ),
    ),
  ),
  v(producers-increases-spacing),
  pad(left: 1em, align(left, {
    set par(spacing: 0.6em)
    [*Increase:*]
    set text(size: 10.2pt)
    for increase in increases {
      [- #increase]
    }
  })),
))

#let scfa-producers(report) = page(background: standard-page-background(section-header: [SCFA Producers]), margin: (
  top: 2.6cm
))[
  #align(center, platinum-table(
    tnum-cols: (0, 2, 3),
    left-align-cols: (1,),
    columns: (10%, 40%, 17%, 17%),
    inset: (x: 0.7em, y: 0.7em),
    table.header(
      [No.],
      align(left)[Bacterial Species],
      [Result],
      [Reference],
    ),
    ..for (i, bacteria) in report.scfa_producers.enumerate() {
      (
        [#(i + 1)],
        [_#bacteria.species _],
        text(fill: rank-to-color(bacteria.result.rank))[*#numfmt(bacteria.result.value)*],
        [#display-range(bacteria.reference_range)],
      )
    },
  ))

  #stack(
    dir: ltr,
    spacing: 0.5em,
    producers-card(
      label: [Acetate Producers],
      tagline: [Microbial cross-feeding & energy metabolism],
      producers: ([Bifidobacterium spp.], [Bacteroides thetaiotaomicron], [Lachnospiraceae spp.]),
      increases: (
        [Insulin],
        [GOS (galacto-oligosaccharides)],
        [Pectin]
      )
    ),
    producers-card(
      label: [Butyrate Producers],
      tagline: [Gut barrier protection & anti-inflammatory signalling],
      producers: (
        [Faecalibacterium prausnitzii],
        [Roseburia intestinalis],
        [Eubacterium rectale],
        [Anaerobutyricum hallii],
        [Coprococcus eutactus],
        [Butyricicoccus pullicaecorum],
        [Anaerostipes hadrus],
        [Clostridium butyricum],
      ),
      arrow-scale: 60%,
      producers-increases-spacing: 0.5cm,
      increases: (
        [Resistant starch],
        [Inulin / FOS fibre],
        [PHGG (Partially Hydrolysed Guar Gum)],
        [Polyphenols (e.g. berries. green tea, cocoa)]
      )
    ),
    producers-card(
      label: [Propionate Producers],
      tagline: [Metabolic signalling & glucose regulation],
      producers: ([Bacteroides thetaiotaomicron], [Prevotella spp.], [Lachnospiraceae spp.]),
      increases: (
        [Whole-grain fibre],
        [Beta-glucans],
        [Resistant starch type III (cooled potatoes, rice)]
      )
    ),
  )
]
