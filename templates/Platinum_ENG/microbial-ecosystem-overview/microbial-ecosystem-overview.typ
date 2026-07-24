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

#let abundance-table-row(name, data) = (
  emph(name),
  [#data.abundance],
  data.logic_operator,
  display-rating(data.rating),
)


#let microbial-ecosystem-overview(report) = page(
  background: standard-page-background(
    section-header: [Microbial Ecosystem Overview],
  ),
)[
  #align(center, stack(dir: ltr, spacing: 1cm, box(align(left, text(size: 12pt)[*Phylum\ Composition*])), rect(
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
                align(center, text(size: 8pt)[#phylum.name\ #strfmt("{:.2}", phylum.abundance)%]),
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

  #align(center)[
    #platinum-table(
      columns: (30%, 20%, 20%, 20%),
      left-align-cols: (0,),
      table.header(
        align(left)[Bacterial Phyla],
        [Relative Abundance (%)],
        [Reference Range (%)],
        [Rating],
      ),
      ..(
        ([Bacteroidetes], report.microbial_ecosystem.bacteroidetes),
        ([Firmicutes], report.microbial_ecosystem.firmicutes),
        ([Firmicutes:Bacteroidetes Ratio\*], report.microbial_ecosystem.firm_bact_ratio),
      )
        .map(((name, data)) => abundance-table-row(name, data))
        .flatten(),
    )
    #platinum-table(
      columns: (30%, 20%, 20%, 20%),
      left-align-cols: (0,),
      table.header(
        align(left)[Endotoxin (LPS) Burden Indicator],
        [Relative Abundance (%)],
        [Reference Range (%)],
        [Rating],
      ),
      ..abundance-table-row([Proteobacteria], report.microbial_ecosystem.proteobacteria),
    )
  ]

  #pad(x: 1cm)[*Note:*\
    Proteobacteria are a major source of endotoxin (LPS), which can activate inflammatory pathways including IL-6 and TNF-α.

    Borderline elevation suggests a potential increase in endotoxin burden, which may contribute to low-grade systemic inflammation, increased intestinal permeability, and metabolic or hepatic stress.

    This metric serves as a practical proxy for total endotoxin (LPS) burden within the gut microbiome.

    \*The Firmicutes: Bacteroidetes ratio reflects the proportional relationship between both phyla and may differ from individual phylum reference ranges.]
]




