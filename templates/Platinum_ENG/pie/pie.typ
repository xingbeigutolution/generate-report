#import "../lib.typ": *
#import "@preview/cetz:0.5.2"

#let movement(seg) = {
  let cluster-size = 0
  let cluster = ()
  let move = (0,)*seg.len()
  for i in range(seg.len()) {
    if seg.at(i) < 30deg {
      move.at(i) = move.at(i - 1) + 1
      cluster-size += 1
    }
    else {
      cluster.push(cluster-size)
      cluster-size = 0
    }
  }
  cluster.push(cluster-size)
  
  let idx = 0
  for k in range(move.len()) {
    if move.at(k) != 0 {
      if cluster.at(idx) == 0 {idx += 1}
      move.at(k) = move.at(k) - (cluster.at(idx) + 1)/2
    }
    else {
      idx += 1
    }
  }

  return move
}


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
    let seg = data.map(phylum => phylum.abundance/ 100 * 360deg)
    let move 
    let index = 0
    for phylum in data {
      stroke(white + 1pt)
      fill(pie-palette.at(calc.rem(index, 8)+1))
      arc((offset, 3), start:offset, stop:offset+seg.at(index), mode:"PIE",radius:3, name:{phylum.name})
      anchor(phylum.name, (offset + seg.at(index) / 2, 3))
      content((offset + seg.at(index) / 2 + movement(seg).at(index) * 10deg, 6.5), align(center, [#phylum.name #phylum.abundance%]), name: "legend")
      line(if offset + seg.at(index) / 2 < 270deg and offset + seg.at(index) / 2 > 90deg {"legend.east"} else {"legend.west"}, phylum.name, stroke:gray)
      offset += seg.at(index)
      index += 1
    }}
)
  on-layer(-1, {
    rect-around("chart", padding: 0.2, fill:rgb("#d0e7ec"), stroke:none)
  })
}))


]




