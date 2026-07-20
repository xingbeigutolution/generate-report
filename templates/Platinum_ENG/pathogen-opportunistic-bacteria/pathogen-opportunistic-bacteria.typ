#import "../lib.typ": *

#let pathogen-opportunistic-bacteria(report) = page(
  background: standard-page-background(
    section-header: [Pathogen and Opportunistic Bacteria],
  ),
  footer: text(
    size: 8pt,
  )[\* Retesting timelines may vary depending on intervention type, clinical presentation, and individual response. Times for reference only],
)[
  #platinum-table(
    left-align-cols: (0, 3),
    columns: (23%, 15%, 15%, 28%, 19%),
    tnum-cols: (1, 2),
    small-font-cols: (3,),
    table.header(
      align(left)[Bacterial Pathogens],
      [Result],
      [Reference],
      [Role / Gut & Host Function / Impact],
      [Retest\ Interval\*],
    ),
    ..for pathogen in report.pathogens {
      (
        [_#pathogen.name _],
        text(fill: rank-to-color(pathogen.result.rank))[*#numfmt(pathogen.result.value)*],
        display-range(pathogen.reference_range),
        [#pathogen.impact],
        [#pathogen.retest_interval],
      )
    },
  )
  #pagebreak()
  #platinum-table(
    left-align-cols: (0, 3),
    columns: (23%, 15%, 15%, 28%, 19%),
    tnum-cols: (1, 2),
    small-font-cols: (3,),
    table.header(
      align(left)[Dysbiotic / Overgrowth Bacteria],
      [Result],
      [Reference],
      [Role / Gut & Host Function / Impact],
      [Retest\ Interval\*],
    ),
    ..for bacteria in report.dysbiotic_overgrowth_bacteria {
      (
        [_#bacteria.name _],
        text(fill: rank-to-color(bacteria.result.rank))[*#numfmt(bacteria.result.value)*],
        display-range(bacteria.reference_range),
        [#bacteria.impact],
        [#bacteria.retest_interval],
      )
    },
  )
  #pagebreak()
  #platinum-table(
    left-align-cols: (0, 3),
    columns: (23%, 15%, 15%, 28%, 19%),
    tnum-cols: (1, 2),
    small-font-cols: (3,),
    table.header(
      align(left)[Commensal Overgrowth & Inflammatory-Related],
      [Result],
      [Reference],
      [Role / Gut & Host Function / Impact],
      [Retest\ Interval\*],
    ),
    ..for bacteria in report.commensal_overgrowth_inflammatory_related {
      (
        [_#bacteria.name _],
        text(fill: rank-to-color(bacteria.result.rank))[*#numfmt(bacteria.result.value)*],
        display-range(bacteria.reference_range),
        [#bacteria.impact],
        [#bacteria.retest_interval],
      )
    },
  )
]
