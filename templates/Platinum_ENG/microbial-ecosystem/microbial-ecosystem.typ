#import "../lib.typ": *
#import "@preview/primaviz:0.8.0": *


#let microbial-ecosystem(report) = page(
  background: standard-page-background(
    section-header: [Microbial Ecosystem Overview],
  )
)[
  #pie-chart(
          (
            labels: (report.microbial_ecosystem.phylum_composition.map(phylum => phylum.name)),
            values: (report.microbial_ecosystem.phylum_composition.map(phylum => phylum.abundance)),
          ),
          show-legend: true,
          size: 150pt,
          theme: (
            palette: (
              rgb("#7a9ec2"),
              rgb("#bfd8ec"),
              rgb("#a0c7e5"),
              rgb("#077098"),
              rgb("#7bb7de"),
              rgb("#638cca"),
              rgb("#5d82e2"),
              rgb("#91b6ef"),
              rgb("#81b9e4"),
              rgb("#6ec1f5"),
            ),
            background: rgb("#d0e7ec"),
            border: none,
            border-radius: 0pt,
          ))
]

