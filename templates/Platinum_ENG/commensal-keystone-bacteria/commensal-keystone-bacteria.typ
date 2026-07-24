#import "../lib.typ": *

#let impact = json("impact.json")

#let commensal-keystone-bacteria(report) = page(background: standard-page-background(
  section-header: [Commensal and Keystone Bacteria],
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
    columns: (23%, 15%, 15%, 32%, 15%),
    tnum-cols: (1, 2),
    left-align-cols: (0, 3),
    small-font-cols: (3,),
    table.header(
      align(left)[Bacterial Species],
      [Result],
      [Reference],
      align(left)[Role / Gut & Host Function / Impact],
      [Retest Interval\*],
    ),
    ..for (bacteria, impact) in report.commensal_keystone_bacteria.zip(impact) {
      (
        [_#bacteria.name _],
        text(fill: rank-to-color(bacteria.result.rank))[*#numfmt(bacteria.result.value)*],
        bacteria.logic_operator,
        [#impact],
        [#rank-to-retest-interval(bacteria.result.rank)],
      )
    },
  )
]
