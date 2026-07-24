#import "../lib.typ": *

#let impact = json("impacts.json")

#let table-row(bacteria, impact) = (
  [_#bacteria.name _],
  text(fill: rank-to-color(bacteria.result.rank))[*#numfmt(bacteria.result.value)*],
  bacteria.logic_operator,
  impact,
  rank-to-retest-interval(bacteria.result.rank),
)

#let table-rows(bacteria, impacts) = {
  for (pathogen, impact) in bacteria.zip(impact.pathogens) {
    table-row(pathogen, impact)
  }
}

#let pathogen-opportunistic-bacteria(report) = page(
  background: standard-page-background(
    section-header: [Pathogen and Opportunistic Bacteria],
  ),
  footer: context[
    #text(
    size: 8pt,
    )[\* Retesting timelines may vary depending on intervention type, clinical presentation, and individual response. Times for reference only]
    #h(1fr)
    #counter(page).display()
  ],
)[
  #platinum-table(
    left-align-cols: (0, 3),
    columns: (23%, 15%, 15%, 28%, 19%),
    tnum-cols: (1, 2),
    small-font-cols: (3,),
    inset: (x: 0.7em),
    table.header(
      align(left)[Bacterial Pathogens],
      [Result],
      [Reference],
      [Role / Gut & Host Function / Impact],
      [Retest\ Interval\*],
    ),
    ..table-rows(report.pathogens, impact.pathogens),
  )
  #pagebreak()
  #platinum-table(
    left-align-cols: (0, 3),
    columns: (23%, 15%, 15%, 28%, 19%),
    tnum-cols: (1, 2),
    small-font-cols: (3,),
    inset: (x: 0.7em),
    table.header(
      align(left)[Dysbiotic / Overgrowth Bacteria],
      [Result],
      [Reference],
      [Role / Gut & Host Function / Impact],
      [Retest\ Interval\*],
    ),
    ..table-rows(report.dysbiotic_overgrowth_bacteria, impact.dysbiotic_overgrowth_bacteria),
  )
  #pagebreak()
  #platinum-table(
    left-align-cols: (0, 3),
    columns: (23%, 15%, 15%, 28%, 19%),
    tnum-cols: (1, 2),
    small-font-cols: (3,),
    inset: (x: 0.7em),
    table.header(
      align(left)[Commensal Overgrowth & Inflammatory-Related],
      [Result],
      [Reference],
      [Role / Gut & Host Function / Impact],
      [Retest\ Interval\*],
    ),
    ..table-rows(report.commensal_overgrowth_inflammatory_related, impact.commensal_overgrowth_inflammatory_related),
  )
]
