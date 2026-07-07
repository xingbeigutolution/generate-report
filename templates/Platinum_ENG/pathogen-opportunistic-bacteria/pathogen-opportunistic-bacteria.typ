#import "../lib.typ": *

#let pathogen-opportunistic-bacteria(report) = page(
  background: standard-page-background(
    section-header: [Pathogen and Opportunistic Bacteria],
  ),
  footer: text(
    size: 8pt,
  )[\* Retesting timelines may vary depending on intervention type, clinical presentation, and individual response. Times for reference only],
)[
  #show table.cell.where(x: 0, y: 0): it => align(start, it)
  #show table.cell.where(y: 0): it => align(center + horizon, strong(it))
  #show table.cell.where(x: 1).or(table.cell.where(x: 2)): it => text(features: ("tnum",), it)
  #table(
    columns: (24%, 15%, 15%, 27%, 19%),
    fill: (x, y) => if y == 0 { primary },
    inset: (x: 0.7em, y: 1em),
    table.header(
      [Bacterial\ Pathogens], [Result], [Reference], [Role / Gut & Host Function / Impact], [Re-test Interval\*]
    ),
    ..for pathogen in report.pathogens {
      (
        align(horizon)[_#pathogen.name _],
        align(center + horizon, text(fill: if within-range(pathogen.reference_range, pathogen.result) { green } else {
          red
        })[*#numfmt(pathogen.result.value)*]),
        align(center + horizon, if pathogen.reference_range.lower == none {
          [<#numfmt(pathogen.reference_range.upper)]
        } else if pathogen.reference_range.upper == none {
          [>#numfmt(pathogen.reference_range.lower)]
        } else {
          box(align(left)[#numfmt(pathogen.reference_range.lower)-\ #numfmt(pathogen.reference_range.upper)])
        }),
        [#text(size: 8pt, pathogen.impact)],
        align(center + horizon)[#pathogen.retest_interval],
      )
    },
  )
]
