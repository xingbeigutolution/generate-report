#import "@preview/hydra:0.6.3": anchor, hydra

#let date-format = "[day]/[month]/[year]"
#let to-date(s) = toml(bytes("date = " + s)).date

#let style(body) = {
  show title: set text(size: 28pt, weight: "medium", tracking: 1.2pt)
  show heading.where(level: 1): set text(size: 18pt, weight: "extrabold", fill: rgb(22,74,100))
  set text(size: 11pt, font: "Inter", weight: "regular", features: ("salt",))
  body
}

#let standard-page-background(section-header: none)= {
  image("images/background-pattern.png")
  place(top, context {
    let header = image("images/header-background.png")
    box(height: measure(header).height, {
      header
      place(horizon, pad(top:1em, left:2em)[= #section-header])
    })
  place(top + end, pad(top: 0.6em, right: 1em, image("images/gutolution_logo_header.png", width: 11em)))
  })
}


#let page-style = {
  let f(it) = {
    set page(
      header: anchor(),
      margin: (top: 4cm, x: 2.3cm, bottom: 1cm),
    )
    it
  }

  f
}