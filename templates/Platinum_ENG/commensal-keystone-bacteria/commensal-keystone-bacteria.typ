#import "../lib.typ": *

#let commensal-keystone-bacteria(report) = page(background: standard-page-background(
  section-header: [Commensal and Keystone Bacteria],
))[
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
      [Retest Interval\*]
    ),
    ..for bacteria in report.commensal_keystone_bacteria {
      (
        [_#bacteria.name _],
        text(fill: green)[*#numfmt(bacteria.result)*],
        display-range(bacteria.reference_range),
        [#bacteria.impact],
        [#bacteria.retest_interval]
      )
    }
  )
]
