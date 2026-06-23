#import "@preview/hydra:0.6.2": anchor, hydra

#let to-string(it) = {
  if type(it) == str {
    it
  } else if type(it) != content {
    str(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  }
}


#let i18n = json("i18n.json")

#let (show_gleneagles_logo: show-gleneagles-logo) = sys.inputs.at("args", default: (show_gleneagles_logo: false))
#let date-format = "[day]/[month]/[year]"
#let neutral = rgb("#B0BDC1")
#let primary = rgb("#44b6bd")
#let secondary = rgb("#3b88c3")
#let destructive = rgb("#CF887C")
#let on-destructive = rgb("#6F2013")
#let constructive = rgb("#A6BAAF")
#let on-constructive = rgb("#415B4D")

#let subtitle(body) = text(body, weight: "extrabold", size: 16pt, fill: rgb("6D6F71"))
#let header-text(body) = text(body, weight: "extrabold", size: 12pt, fill: primary.darken(20%).transparentize(15%))
#let footer-text(body) = text(body, size: 14pt, fill: neutral)

#let section-heading(body, is-numbered-section: true) = align(center, context {
  if is-numbered-section {
    counter(heading).step()
  }
  underline(offset: 0.5em)[= #if is-numbered-section [#counter(heading).get().first()\.] #body]
})

#let leftpad(len, pad, s) = {
  if str(s).len() < len {
    leftpad(len, pad, pad + str(s))
  } else {
    s
  }
}

#let is-alpha(s) = {
  for c in s {
    if not ((c >= "A" and c <= "Z") or (c >= "a" and c <= "z")) {
      return false
    }
  }
  true
}

#let longest-alpha-sequence(s) = {
  s.split(" ").filter(substr => is-alpha(substr)).join(" ")
}

#let to-date(s) = toml(bytes("date = " + s)).date

#let warn(body) = page(align(center, box(
  width: 200pt,
  fill: red.lighten(50%),
  radius: 7pt,
  table(
    columns: (30%, 70%),
    stroke: none,
    align: center + horizon,
    text(size: 30pt)[⛔️], text(fill: red.darken(50%), body),
  ),
)))

#let standard-page-background(report) = context {
  align(top)[
    #image("images/header-background.png")
    #place(top + start, pad(top: 1em, left: 1em, image(if show-gleneagles-logo {
      "images/gleneagles-header-logo-full.png"
    } else { "images/gutolution-logo-banner.png" }, width: 13.5em)))
    #place(top + end, pad(top: 20pt, right: 15pt, header-text[
      #i18n.at(report.product).zh_HK\
      #report.product
    ]))
    #header-text[User Name |] #h(1em)#report.report_information.user_full_name #h(4em) #header-text[Report Date |] #h(
      1em,
    )#report.report_information.date_of_report.display(
      date-format,
    )
    #place(bottom, box(
      height: 40pt,
      width: 100%,
      align(horizon, footer-text(table(
        columns: (1fr, auto, 70pt),
        gutter: 0pt,
        inset: 0pt,
        stroke: none,
        line(stroke: (paint: primary, dash: "dotted", thickness: 2pt), length: 100%),
        pad(x: 15pt, {
          let heading-components = hydra(1, skip-starting: false, use-last: true)
          if heading-components != none {
            let heading = to-string(heading-components)
            // if heading
            longest-alpha-sequence(to-string(heading-components))
          }
        }),
        align(
          left,
        )[*#text(fill: primary.darken(20%))[#{ counter(page).display() }] / #{ counter(page).final().at(0) }*],
      ))),
    ))
  ]
};

#let bad-excellent = 1
#let excellent-bad = -1
#let bad-excellent-colors = ("CF887C", "987AAB", "7C91A6", "EBC1A8", "A6BAAF")
#let deficient-abundant-colors = ("987AAB", "7C91A6", "A6BAAF", "EBC1A8", "CF887C")
#let bad-excellent-caption = {
  let bad-excellent-caption-en = (
    "Bad",
    "Fair",
    "Average",
    "Good",
    "Excellent",
  )
  bad-excellent-caption-en
    .zip(bad-excellent-caption-en.map(caption => i18n.at(caption)))
    .map(((en_HK, translation)) => (en_HK: en_HK, zh_HK: translation.zh_HK))
}

#let deficient-abundant-caption = {
  let deficient-abundant-caption-en = (
    "Highly Deficient",
    "Slightly Deficient",
    "Balanced",
    "Slightly Overabundant",
    "Highly Overabundant",
  )
  deficient-abundant-caption-en
    .zip(deficient-abundant-caption-en.map(
      caption => i18n.at(caption),
    ))
    .map(((en_HK, translation)) => (en_HK: en_HK, zh_HK: translation.zh_HK))
}

#let slider(
  value: 0,
  semantics: bad-excellent,
  color-scheme: bad-excellent-colors,
  caption-scheme: none,
  caption-show-zh-hk: false,
  graphics-scheme: none,
  width: 100%,
  bar-height: 12pt,
  arrow-width: auto,
) = context {
  let len = color-scheme.len()
  assert(len > 0)
  assert(value == none or (0 <= value and value < len))
  assert(caption-scheme == none or caption-scheme.len() == len)
  assert(graphics-scheme == none or graphics-scheme.len() == len)

  let bar-colour(value, semantics: bad-excellent) = if semantics == bad-excellent {
    rgb(color-scheme.at(value))
  } else {
    bar-colour(len - 1 - value)
  }

  let caption(this-value, semantics: bad-excellent) = if caption-scheme != none {
    set text(size: 14pt, fill: bar-colour(this-value, semantics: semantics), weight: "extrabold")
    if semantics == bad-excellent {
      if caption-show-zh-hk {
        [#set par(leading: 0.4em)
          #caption-scheme.at(this-value).zh_HK\
          #text(size: 10pt, caption-scheme.at(this-value).en_HK)]
      } else {
        [#caption-scheme.at(this-value).en_HK]
      }
    } else {
      caption(len - 1 - this-value)
    }
  }

  let arrow-down = image("images/arrow-down.png", width: arrow-width)
  let slider-slice(this-value) = stack(
    align(center, if graphics-scheme != none { graphics-scheme.at(this-value) }),
    align(center, if this-value == value { arrow-down } else {
      if value != none { box(height: measure(arrow-down).height) }
    }),
    box(
      width: 100%,
      height: bar-height,
      radius: (left: if this-value == 0 { 50% } else { 0% }, right: if this-value == len - 1 { 50% } else { 0% }),
      fill: bar-colour(this-value, semantics: semantics),
    ),
    ..if caption-scheme != none {
      (
        v(1.5em),
        align(center, caption(
          this-value,
          semantics: semantics,
        )),
      )
    },
  )

  box(width: width, table(
    columns: range(len).map(_ => 1fr),
    stroke: none,
    column-gutter: 2pt,
    inset: 0pt,
    ..range(len).map(i => slider-slice(i))
  ))
}

#let baseline = 0
#let elevated = 1
#let risk-pill(risk: baseline) = box(
  radius: 50%,
  fill: if risk == baseline { constructive } else { destructive },
  inset: 1em,
  align(center + horizon, text(
    fill: if risk == baseline { on-constructive } else { on-destructive },
    weight: "bold",
  )[#(if risk == elevated { i18n.at("Elevated Risk").zh_HK } else { i18n.at("Baseline Risk").zh_HK })\ #(
      if risk == elevated { "Elevated Risk" } else { "Baseline Risk" }
    )]),
)

#let style(body) = {
  show title: set text(fill: rgb("#6D6F71"), size: 36pt)
  show heading: set text(weight: "extrabold", size: 24pt, fill: primary.darken(20%))
  show heading.where(level: 2): set text(weight: "extrabold", size: 24pt, fill: primary.darken(20%))
  show heading.where(level: 2): it => align(center, underline(offset: 5pt, stroke: 1pt, it))
  show heading.where(level: 3): it => align(center, text(
    weight: "bold",
    size: 18pt,
    fill: primary.darken(20%),
    it.body,
  ))
  set text(size: 12pt, font: ((name: "Mulish", covers: "latin-in-cjk"), "Noto Sans TC"), weight: "medium")
  show smartquote: set text(features: ("pwid",)) 

  body
}

#let page-style(report) = {
  let f(it) = {
    set page(
      header: anchor(),
      background: standard-page-background(report),
      margin: (top: 4cm, x: 2.3cm, bottom: 1cm),
    )
    it
  }

  f
}

#let body-style(body) = {
  set par(justify: true)
  set page(margin: (x: 1.8cm))
  set text(size: 11pt, hyphenate: false)

  body
}
