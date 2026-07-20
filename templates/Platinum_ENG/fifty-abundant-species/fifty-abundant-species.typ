#import "../lib.typ": *

#let fifty-abundant-species(report) = page(background: standard-page-background(
  section-header: [Your 50 Most Abundant Species],
))[
  #align(center, platinum-table(
    columns: (10%, 43%, 35%),
    left-align-cols: (1,),
    tnum-cols: (2,),
    table.header(
      [No.],
      align(left)[Bacterial Species],
      [Relative Abundance (%)],
    ),
    ..for (i, bacteria) in report.fifty_abundant_species.enumerate() {
      ([#(i+1)], [_#bacteria.species _], [#bacteria.abundance])
    },
  ))
]
