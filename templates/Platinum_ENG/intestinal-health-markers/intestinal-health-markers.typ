#import "../lib.typ": *

#let intestinal-health-markers(report) = page(
  background: standard-page-background(
    section-header: [Intestinal Health Markers],
  ),
  footer: text(
    size: 8pt,
  )[\* Retesting timelines may vary depending on intervention type, clinical presentation, and individual response. Times for reference only],
)[
  #show table.cell.where(x:1, y:0): it => align(start, it)
  #show table.cell.where(x:2, y:0): it => align(start, it)
  #show table.cell.where(y: 0): it => align(center + horizon, strong(it))
  #show table.cell.where(x: 1).or(table.cell.where(x: 2)): it => text(features: ("tnum",), it)
  #table(
    columns: (7%, 23%, 23%, 16%, 16%, 16%),
    fill: (x, y) => if y == 0 { primary },
    inset: (x: 0.7em, y: 1em),
    table.header(
      [No.], [Marker], [Function], [Result], [Reference], [Re-test Interval\*]
    ),
    ..for intestinal in report.intestinal_health_markers {
      (
        align(center + horizon)[#intestinal.result.rank],
        align(horizon)[#intestinal.name],
        align(horizon)[#intestinal.function],
        align(center + horizon, text(fill: if within-range(intestinal.reference_range, intestinal.result.value) { green } else {
          red
        })[*#numfmt_i(intestinal.result.value) #intestinal.result.unit*]),
        align(center + horizon, if intestinal.reference_range.lower == none {
          [<#numfmt_i(intestinal.reference_range.upper) #intestinal.reference_range.unit]
        } else if intestinal.reference_range.upper == none {
          [>#numfmt_i(intestinal.reference_range.lower) #intestinal.reference_range.unit]
        } else {
          box(align(left)[#numfmt_i(intestinal.reference_range.lower)-\ #numfmt_i(intestinal.reference_range.upper) #intestinal.reference_range.unit])
        }),
        align(center + horizon)[#intestinal.retest_interval],
      )
    }
  )
]