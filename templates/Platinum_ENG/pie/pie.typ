#import "../lib.typ": *
#import "@preview/cetz:0.5.2"


#let pie(report) = page(
  background: standard-page-background(
    section-header: [Microbial Ecosystem Overview],
  ),
)[
  #align(center, cetz.canvas({
    import cetz.draw: *

    let data = report.microbial_ecosystem.phylum_composition

    let segment(from, to, name: none) = {
      merge-path(close: true, {
        line((0, 0), (rel: (from, 3)))
        arc((), start: from, stop: to, radius: 3)
      })
    }

    group(name: "chart", {
      let offset = 0deg
      let last = 360deg
      let index = 1
      for phylum in data {
        stroke(white + 1pt)
        fill(pie-palette.at(index))
        let seg = float(phylum.abundance) / 100 * 360deg
        segment(offset, offset + seg, name: "phylum.name")
        anchor(phylum.name, (offset + seg / 2, 3))
        if last < 30deg {
          content(
            (offset + seg / 2 + 10deg, 5.5),
            align(center, { phylum.name + "\n" + str(phylum.abundance) + "%" }),
            name: "legend",
          )
        } else {
          content(
            (offset + seg / 2, 5.5),
            align(center, { phylum.name + "\n" + str(phylum.abundance) + "%" }),
            name: "legend",
          )
        }
        line(phylum.name, "legend", stroke: gray)
        last = seg
        offset += seg
        index += 1
      }
    })
    on-layer(-1, {
      rect-around("chart", padding: 0.2, fill: rgb("#d0e7ec"), stroke: none)
    })
    arc((3,0), start: 0deg, delta: 25deg, mode: "PIE", radius: 3, fill: red, stroke: black)
    arc((), start: 25deg, delta: 105deg, mode: "PIE", radius: 3, fill: green, stroke: black)
  }))

]




