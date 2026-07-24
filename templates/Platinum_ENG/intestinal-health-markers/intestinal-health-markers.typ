#import "../lib.typ": *

#let marker-functions = json("marker-functions.json")

#let intestinal-health-markers(report) = page(
  background: standard-page-background(
    section-header: [Intestinal Health Markers],
  ),
  footer: context[
    #text(
    size: 8pt,
    )[\* Retesting timelines may vary depending on intervention type, clinical presentation, and individual response. Times for reference only]
    #h(1fr)
    #counter(page).display()
  ],
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
    ..for (i, (marker, function)) in report.intestinal_health_markers.zip(marker-functions).enumerate() {
      (
        [#(i + 1)],
        [#marker.name],
        [#function],
        text(fill: rank-to-color(marker.result.rank))[*#marker.result.value #marker.unit*],
        [#marker.logic_operator],
        [#rank-to-retest-interval(marker.result.rank)],
      )
    },
  )
]
