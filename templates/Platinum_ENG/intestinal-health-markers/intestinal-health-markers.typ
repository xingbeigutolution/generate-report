#import "../lib.typ": *

#let intestinal-health-markers(report) = page(
  background: standard-page-background(
    section-header: [Intestinal Health Markers],
  ),
  footer: text(
    size: 8pt,
  )[\* Retesting timelines may vary depending on intervention type, clinical presentation, and individual response. Times for reference only],
)[
  #platinum-table(
    left-align-cols: (1, 2),
    tnum-cols: (3, 4),
    columns: (7%, 23%, 23%, 16%, 16%, 16%),
    table.header(
      [No.],
      align(left)[Marker],
      align(left)[Function],
      [Result],
      [Reference],
      [Re-test Interval\*],
    ),
    ..for (i, marker) in report.intestinal_health_markers.enumerate() {
      (
        [#(i + 1)],
        [#marker.name],
        [#marker.function],
        text(fill: rank-to-color(marker.result.rank))[*#marker.result.value #marker.unit*],
        [#display-range(marker.reference_range) #marker.unit],
        [#marker.retest_interval]
      )
    },
  )
]
