#import "../lib.typ": *

#let non-bacterial-members(report) = page(
  background: standard-page-background(
    section-header: [Non-Bacterial Members],
  ),
  footer: text(
    size: 8pt,
  )[\* Retesting timelines may vary depending on intervention type, clinical presentation, and individual response. Times for reference only],
)[
  #set par(spacing: 0em)

  #platinum-table(
    tnum-cols: (1, 2),
    left-align-cols: (0, 3),
    columns: (23%, 15%, 15%, 32%, 15%),
    inset: (x: 0.7em, y: 0.6em),
    table.header(
      align(left)[Parasitic Pathogens],
      [Result],
      [Reference],
      align(left)[Role / Gut & Gost Function / Impact],
      [Re-test Interval\*],
    ),
    ..for parasite in report.non_bacterial_members.parasites {
      (
        [_#parasite.name _],
        text(fill: rank-to-color(parasite.result.rank))[*#numfmt(parasite.result.value)*],
        display-range(parasite.reference_range),
        text(size: 8pt)[#parasite.impact],
        [#parasite.retest_interval],
      )
    },
  )
  #platinum-table(
    columns: (23%, 15%, 15%, 32%, 15%),
    left-align-cols: (0, 3),
    tnum-cols: (1, 2),
    inset: (x: 0.7em, y: 0.6em),
    table.header(
      align(left)[Viral Pathogens],
      [Result],
      [Reference],
      align(left)[Role / Gut & Gost Function / Impact],
      [Re-test Interval\*],
    ),
    ..for virus in report.non_bacterial_members.virus {
      (
        [_#virus.name _],
        text(fill: rank-to-color(virus.result.rank))[*#numfmt(virus.result.value)*],
        display-range(virus.reference_range),
        text(size: 8pt)[#virus.impact],
        [#virus.retest_interval],
      )
    },
  )
  #platinum-table(
    columns: (23%, 15%, 15%, 32%, 15%),
    left-align-cols: (0, 3),
    tnum-cols: (1, 2),
    inset: (x: 0.7em, y: 0.6em),
    table.header(
      align(left)[Viral Pathogens],
      [Result],
      [Reference],
      align(left)[Role / Gut & Gost Function / Impact],
      [Re-test Interval\*],
    ),
    ..for virus in report.non_bacterial_members.virus {
      (
        [_#virus.name _],
        text(fill: rank-to-color(virus.result.rank))[*#numfmt(virus.result.value)*],
        display-range(virus.reference_range),
        text(size: 8pt)[#virus.impact],
        [#virus.retest_interval],
      )
    },
  )
  #platinum-table(
    columns: (23%, 15%, 15%, 32%, 15%),
    left-align-cols: (0, 3),
    tnum-cols: (1, 2),
    inset: (x: 0.7em, y: 0.6em),
    table.header(
      align(left)[Fungi/Yeast],
      [Result],
      [Reference],
      align(left)[Role / Gut & Gost Function / Impact],
      [Re-test Interval\*],
    ),
    ..for fungi in report.non_bacterial_members.fungi {
      (
        [_#fungi.name _],
        text(fill: rank-to-color(fungi.result.rank))[*#numfmt(fungi.result.value)*],
        display-range(fungi.reference_range),
        text(size: 8pt)[#fungi.impact],
        [#fungi.retest_interval],
      )
    },
  )
  #platinum-table(
    columns: (23%, 15%, 42%, 20%),
    left-align-cols: (0, 2),
    inset: (x: 0.7em, y: 0.6em),
    table.header(
      pad(0.3em, align(left)[Protozoa & Worms]), // Hack: maintain visual balance by adding extra padding to header
      [Result],
      align(left)[Role / Gut & Gost Function / Impact],
      [Re-test Interval\*],
    ),
    ..for protozoa in report.non_bacterial_members.protozoa {
      (
        [_#protozoa.name _],
        text(fill: if protozoa.detected { red } else { green })[*#if protozoa.detected [Detected] else [Not Detected]*],
        text(size: 8pt)[#protozoa.impact],
        [#protozoa.retest_interval],
      )
    },
  )
]
