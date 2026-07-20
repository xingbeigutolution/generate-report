#import "@preview/hydra:0.6.3": anchor, hydra
#import "@preview/oxifmt:1.0.0": strfmt

#let numfmt(num) = strfmt("{:.2E}", num) //number format for pathogen and opportunistic bacteria
#let numfmt_i(num) = {
  if num < 1E-6 or num > 1E6 {
    return strfmt("{:.2E}", num)
  } else { num }
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

#let primary-container = rgb("b4dee8")
#let primary = rgb("0097b2")
#let green = rgb("56bc6c")
#let red = rgb("de4d46")
#let yellow = yellow.darken(5%)
#let grey = rgb("595959")
#let pie-palette = ( 
    rgb("#bfd8ec"), 
    rgb("#a0c7e5"),
    rgb("#91b6ef"), 
    rgb("#7bb7de"), 
    rgb("#7a9ec2"),  
    rgb("#5d82e2"),
    rgb("#638cca"),  
    rgb("#077098"),
  )

#let style(body) = {
  show title: set text(size: 28pt, weight: "medium", tracking: 1.2pt)
  show heading.where(level: 1): set text(size: 18pt, weight: "extrabold", fill: rgb(22, 74, 100))
  set heading()
  set text(size: 11pt, font: "Inter", weight: "regular")
  body
}

#let standard-page-background(section-header: none) = {
  image("images/background-pattern.svg")
  place(top, context {
    let header = image("images/header-background.svg")
    box(height: measure(header).height, {
      header
      place(horizon, pad(top: 1em, left: 2em)[= #section-header])
    })
    place(top + end, pad(top: 0.6em, right: 2em, image("images/gutolution-logo-header.svg", width: 10em)))
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
    set text(features: ("cv05",))
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

#let platinum-table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  tnum-cols: (),
  left-align-cols: (),
  small-font-cols: (),
  inset: (x: 0.7em, y: 1em),
  ..values,
) = {
  show: it => tnum-cols.fold(it, (it, col) => {
    show table.cell.where(x: col): cell => if cell.y > 0 { text(number-width: "tabular", cell) } else { cell }
    it
  })
  show: it => left-align-cols.fold(it, (it, col) => {
    show table.cell.where(x: col): cell => if cell.y > 0 { align(start, cell) } else { cell }
    it
  })
  show: it => small-font-cols.fold(it, (it, col) => {
    show table.cell.where(x: col): cell => if cell.y > 0 { text(size: 8pt, cell) } else { cell }
    it
  })

  set table(fill: (x, y) => if y == 0 { primary-container }, inset: inset, stroke: grey.lighten(60%))
  show table.cell: it => if it.y > 0 { text(size: 10pt, it) } else { it }
  show table.cell.where(y: 0): strong
  show table.cell: it => align(horizon + center, it)

  table(
    columns: columns,
    ..values
  )
}

#let display-range(range) = align(center + horizon, if range.lower == none {
  [<#numfmt(range.upper)]
} else if range.upper == none {
  [>#numfmt(range.lower)]
} else {
  pad(left: 1em, box(align(left)[#numfmt(range.lower)-\ #numfmt(range.upper)]))
})
#let rank-to-color(rank) = if rank == 2 { yellow } else if rank == 3 { red } else { green }
