#import "@preview/hydra:0.6.3": anchor, hydra
#import "@preview/oxifmt:1.0.0": strfmt

#let numfmt(num) = strfmt("{:.2E}", num) //number format for pathogen and opportunistic bacteria
#let numfmt_i(num) = {
  if num < 1E-6 or num > 1E6 {
    return strfmt("{:.2E}", num)
  } 
  else {num}
} //number format for intestinal health markers
#let within-range(range, num) = {
  if (range.lower != none and num < range.lower) {
    return false
  }
  if (range.upper != none and num > range.upper) {
    return false
  }
  true
}

#let date-format = "[day]/[month]/[year]"
#let to-date(s) = toml(bytes("date = " + s)).date

#let primary = rgb("b4dee8")
#let green = rgb("56bc6c")
#let red = rgb("de4d46")
#let grey = rgb("595959")

#let style(body) = {
  show title: set text(size: 28pt, weight: "medium", tracking: 1.2pt)
  show heading.where(level: 1): set text(size: 18pt, weight: "extrabold", fill: rgb(22, 74, 100))
  set text(size: 11pt, font: "Inter", weight: "regular", features: ("salt",))
  body
}

#let standard-page-background(section-header: none) = {
  image("images/background-pattern.svg")
  place(top, context {
    let header = image("images/header-background.png")
    box(height: measure(header).height, {
      header
      place(horizon, pad(top: 1em, left: 2em)[= #section-header])
    })
    place(top + end, pad(top: 0.6em, right: 1em, image("images/gutolution_logo_header.png", width: 11em)))
  })
}

#let page-style = {
  let f(it) = {
    set page(
      header: anchor(),
      margin: (top: 3cm, x: 1.2cm, bottom: 1.2cm),
      numbering: "1",
      number-align: end,
    )
    it
  }

  f
}

#let captialize(s) = {
  if s.len() > 0 {
    return upper(s.slice(0, 1)) + s.slice(1)
  }
  s
}
