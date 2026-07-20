#import "../lib.typ": *
#import "@preview/cetz:0.5.2"

#let cluster(seg) = {
  let seg_round = seg
  seg_round.push(seg.at(0))
  let legend = (false,) * seg.len()

  for i in range(seg.len()) {
    if seg_round.at(i) < 30deg {
      if i != 0 and legend.at(i - 1) == true {
        legend.at(i) = true
      } else if seg_round.at(i + 1) < 30deg {
        legend.at(i) = true
      }
    }
  }

  if seg.at(0) < 30deg and legend.at(seg.len()) == true {
    legend.at(0) == true
  }

  return legend
}


#let microbial-ecosystem-overview(report) = page(
  background: standard-page-background(
    section-header: [Microbial Ecosystem Overview],
  ),
)[
  #align(center, stack(dir: ltr, spacing: 0.3cm, box(align(left, text(size: 12pt)[*Phylum\ Composition*])), rect(
    fill: rgb("#d0e7ec"),
    width: 70%,
    height: 9cm,
    (
      align(center + horizon, cetz.canvas({
        import cetz.draw: *

        let data = report.microbial_ecosystem.phylum_composition

        group(name: "chart", {
          let offset = 0deg
          let seg = data.map(phylum => phylum.abundance / 100 * 360deg)
          let legend_idx = cluster(seg).enumerate().filter(pair => pair.at(1)).map(pair => pair.at(0))

          for (index, phylum) in data.enumerate() {
            stroke(white + 1pt)
            fill(pie-palette.at(calc.rem(index, 8)))
            arc((offset, 2.5), start: offset, stop: offset + seg.at(index), mode: "PIE", radius: 2.5, name: {
              phylum.name
            })
            anchor(phylum.name, (offset + seg.at(index) / 2, 2.5))
            if index not in legend_idx {
              content(
                (offset + seg.at(index) / 2, 4),
                align(center, text(size: 8pt)[#phylum.name\ #phylum.abundance%]),
                name: "label",
              )
              line(
                "label",
                phylum.name,
                stroke: gray,
              )
            }

            offset += seg.at(index)
          }

          if legend_idx.len() > 0 {
            content(
              (4.5, 3.5),
              anchor: "west",
              name: "legend",
              stack(
                spacing: 0.5em,
                ..for (i, index) in legend_idx.enumerate() {
                  let phylum = data.at(index)
                  (
                    text(
                      size: 8pt,
                    )[#box(width: 1em, height: 1em, fill: pie-palette.at(calc.rem(index, 8))) #phylum.name #phylum.abundance%],
                  )
                },
              ),
            )
          }
        })
      }))
    ),
  )))
]




