#import "../lib.typ": *

#let impacts = json("impact.json")

#let non-bacterial-members(report) = page(
  background: standard-page-background(
    section-header: [Non-Bacterial Members],
  ),
  footer: context[
    #text(
    size: 8pt,
    )[\* Retesting timelines may vary depending on intervention type, clinical presentation, and individual response. Times for reference only]
    #h(1fr)
    #counter(page).display()
  ],
)[
  #set par(spacing: 0em)

  #platinum-table(
    tnum-cols: (1, 2),
    left-align-cols: (0, 3),
    columns: (23%, 15%, 15%, 32%, 15%),
    small-font-cols: (3,),
    table.header(
      align(left)[Parasitic Pathogens],
      [Result],
      [Reference],
      align(left)[Role / Gut & Gost Function / Impact],
      [Re-test Interval\*],
    ),
    ..for (parasite, impact) in report.non_bacterial_members.parasites.zip(impacts.parasitic_pathogens) {
      (
        [_#parasite.name _],
        text(fill: detected-to-color(parasite.result.detected))[*#numfmt(parasite.result.value)*],
        parasite.logic_operator,
        impact,
        detected-to-retest-interval(parasite.result.detected),
      )
    },
  )
  #platinum-table(
    columns: (23%, 15%, 15%, 32%, 15%),
    left-align-cols: (0, 3),
    tnum-cols: (1, 2),
    inset: (x: 0.7em, y: 0.6em),
    small-font-cols: (3,),
    table.header(
      align(left)[Viral Pathogens],
      [Result],
      [Reference],
      align(left)[Role / Gut & Gost Function / Impact],
      [Re-test Interval\*],
    ),
    ..for (virus, impact) in report.non_bacterial_members.virus.zip(impacts.viral_pathogens) {
      (
        [_#virus.name _],
        text(fill: rank-to-color(virus.result.rank))[*#numfmt(virus.result.value)*],
        virus.logic_operator,
        impact,
        rank-to-retest-interval(virus.result.rank),
      )
    },
  )
  #platinum-table(
    columns: (23%, 15%, 15%, 32%, 15%),
    left-align-cols: (0, 3),
    tnum-cols: (1, 2),
    inset: (x: 0.7em, y: 0.6em),
    small-font-cols: (3,),
    table.header(
      align(left)[Fungi/Yeast],
      [Result],
      [Reference],
      align(left)[Role / Gut & Gost Function / Impact],
      [Re-test Interval\*],
    ),
    ..for (fungi, impact) in report.non_bacterial_members.fungi.zip(impacts.fungi) {
      (
        [_#fungi.name _],
        text(fill: rank-to-color(fungi.result.rank))[*#numfmt(fungi.result.value)*],
        fungi.logic_operator,
        impact,
        rank-to-retest-interval(fungi.result.rank),
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
    ..for (protozoa, impact) in report.non_bacterial_members.protozoa.zip(impacts.protozoa_worms) {
      (
        [_#protozoa.name _],
        text(fill: detected-to-color(
          protozoa.result.detected,
        ))[*#if protozoa.result.detected [Detected] else [Not Detected]*],
        text(size: 8pt)[#impact],
        [#detected-to-retest-interval(protozoa.result.detected)],
      )
    },
  )
]
