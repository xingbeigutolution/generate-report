#import "../lib.typ": *

#let probiotic-bacterial-members(report) = page(background: standard-page-background(
  section-header: [Probiotic Bacterial Members],
))[
  #platinum-table(
    columns: (34%, 15.5%, 15.5%, 35%),
    left-align-cols: (0, 3),
    tnum-cols: (1, 2),
    small-font-cols: (3,),
    inset: (x: 0.7em, y: 0.95em),
    table.header(
      align(left)[Bacterial Species],
      [Result],
      [Reference],
      align(left)[Role / Gut & Host Function / Impact],
    ),
    ..for bacteria in report.probiotic_bacterial_members {
      (
        [_#bacteria.name _],
        text(fill: rank-to-color(bacteria.result.rank))[*#numfmt(bacteria.result.value)*],
        display-range(bacteria.reference_range),
        [#bacteria.impact],
      )
    },
  )
  #pad(x: 1em)[
    #set text(size: 10pt)
    *Note*:\
    Probiotic effects on histamine are *strain-specific* and context-dependent, and may vary based on host microbiome composition. While some strains (e.g. _Bifidobacterium longum_, _B. infantis_, _Lactobacillus plantarum_) may support *histamine degradation*, others (e.g. _Lactobacillus casei_, _L. reuteri_, _L. bulgaricus_) may *produce histamine*. Clinical selection should be guided accordingly.
  ]
]
