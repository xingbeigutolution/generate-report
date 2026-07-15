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

  group(name: "chart", {
    let offset = 0deg
    let last-seg = 360deg
    let index = 1
    for phylum in data {
      stroke(white + 1pt)
      fill(pie-palette.at(calc.rem(index, 8)+1))
      let seg = float(phylum.abundance) / 100 * 360deg
      arc((offset, 3), start:offset, stop:offset+seg, mode:"PIE",radius:3, name:{phylum.name})
      anchor(phylum.name, (offset + seg / 2, 3))
      content((offset + seg / 2 + if (last-seg+seg)/2 < 15deg {10deg} else {0deg}, 5.5), align(center, [#phylum.name #phylum.abundance%]), name: "legend")
      line(phylum.name, "legend", stroke:gray)
      last-seg = seg
      offset += seg
      index += 1
    }}
)
  on-layer(-1, {
    rect-around("chart", padding: 0.2, fill:rgb("#d0e7ec"), stroke:none)
  })
}))


]




