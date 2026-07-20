#import "../lib.typ": *

#let appendix(report) = page(background: standard-page-background(section-header: [Appendix]), margin: (right: 2cm))[
  #set enum(numbering: (it => strong([#it.])))
  #set list(indent: 1em)
  #set par(leading: 0.8em)

  #show heading.where(level: 2): set heading(numbering: (first, ..nums) => numbering("1.", ..nums))
  #show heading.where(level: 3): set text(fill: primary.darken(40%))

  == Reference Ranges -- Source and Development
  Reference ranges displayed in this report are generated using GUTolution's internal microbiome analytics framework. These ranges are informed by a combination of:

  - Aggregated anonymised microbiome sample data
  - Published scientific literature and benchmark datasets
  - Statistical distribution modelling across measured markers
  - Ongoing technical review and refinement as new data becomes available

  These ranges are designed to support interpretation of gut microbiome balance and functional trends. They are not intended to diagnose disease in isolation and should be interpreted alongside symptoms, medical history, diet, and practitioner guidance.

  \
  == Units & Numerical Values
  Results in this report may be presented in different formats depending on the marker assessed.

  === Microbial markers (NGS / molecular analysis):
  Values generally represent estimated relative abundance, normalized analytical signal, or comparative marker levels within the stool sample.

  === Biomarker markers (e.g. calprotectin, zonulin, elastase):
  Reported using conventional concentration units such as ng/mL, μg/g, U/L, or equivalent assay units.

  === Scientific notation may be used for compact display
  Examples:\
  #text(number-width: "tabular")[
    #numfmt(1.0e3) = 1,000\ #numfmt(2.5e6) = 2,500,000\ #numfmt(3.1e-2) = 0.031
  ]

  Values shown as \<DL indicate levels below the assay detection limit.

  #pagebreak()

  == Colour Thresholds & Scoring Logic
  To support rapid interpretation, results are colour-coded according to deviation from the expected reference range.

  🟢 #text(fill: primary.darken(40%))[Green = Within Expected Range]\
  The result falls within the healthy reference interval or accepted interpretation threshold for that marker.

  🟠 #text(fill: primary.darken(40%))[Amber = Borderline / Mild Deviation]\
  The result is modestly outside the ideal range, typically within approximately 20% above or below the reference threshold, and may benefit from monitoring or optimisation.

  🔴 #text(fill: primary.darken(40%))[Red = Significant Deviation]\
  The result is meaningfully outside the expected range, generally exceeding the borderline threshold, and may warrant focused attention in the report interpretation.

  Where markers use lower-limit thresholds (e.g. beneficial bacteria), reduced values may trigger Amber or Red. Where upper-limit thresholds are used (e.g. opportunistic organisms or inflammation markers), elevated values may trigger Amber or Red.

  \
  *Important Note*\
  Microbiome patterns are dynamic and influenced by diet, lifestyle, stress, medication use, sleep, illness, and recent travel. A single result should be interpreted as part of the wider clinical picture rather than in isolation.
]
