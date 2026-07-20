#import "../lib.typ": *
#import "@preview/shadowed:0.3.0": shadow

#let comment-card(label, comments) = shadow(
  blur: 8pt,
  dx: 0.5em,
  dy: 0.5em,
  fill: gray.lighten(10%).transparentize(50%),
  rect(
    width: 50%,
    height: 5.5cm,
    fill: rgb("f9f9f9"),
    inset: 7pt,
    stack(
      spacing: 0.7em,
      align(center, rect(
        inset: 7pt,
        width: 70%,
        fill: primary-container.lighten(20%),
        radius: 50%,
        text(size: 12pt, fill: primary)[*#label*],
      )),
      {
        set par(spacing: 0.8em, leading: 0.4em)
        set text(size: 10pt)
        for comment in comments {
          align(left)[
            - #comment
          ]
        }
      },
    ),
  ),
)

#let at-a-glance(report) = page(background: standard-page-background(section-header: [At a glance..]))[
  #let bacteria-list = (
    "bacteroidetes",
    "actinobacteria",
    "verrucomicrobiota",
    "mycoplasmatota",
    "proteobacteria",
    "firmicutes",
  )
  #let colors = (green, yellow, red).map(color => color.transparentize(50%))
  #box(
    width: 100%,
    height: 40%,
  )[
    #let dist = 2.85cm
    #for (i, bacteria) in bacteria-list.enumerate() {
      let theta = i * 60 * 1deg
      let x = dist * calc.sin(theta)
      let y = -dist * calc.cos(theta)
      place(center + horizon, dx: x, dy: y, polygon.regular(vertices: 6, size: 85pt, stroke: 2.5pt, fill: colors.at(
        report.at_a_glance.at(bacteria) - 1,
      )))
    }
    #place(center + horizon, polygon.regular(vertices: 6, size: 85pt, stroke: 2.5pt))
    #place(center + horizon, dx: 0cm, dy: -4.7cm, text(fill: grey, size: 14pt)[*Bacteroidetes*])
    #place(center + horizon, dx: 6cm, dy: -1.5cm, text(fill: grey, size: 14pt)[*Actinobacteria*])
    #place(center + horizon, dx: 6.5cm, dy: 1.5cm, text(fill: grey, size: 14pt)[*Verrucomicrobiota*])
    #place(center + horizon, dx: 0cm, dy: 4.7cm, text(fill: grey, size: 14pt)[*Mycoplasmatota*])
    #place(center + horizon, dx: -6.1cm, dy: 1.5cm, text(fill: grey, size: 14pt)[*Proteobacteria*])
    #place(center + horizon, dx: -5.6cm, dy: -1.5cm, text(fill: grey, size: 14pt)[*Firmicutes*])
    #place(center + horizon, dx: -1.9cm, dy: -4cm, image("images/arrow-left.png"))
    #place(center + horizon, dx: -4.3cm, dy: -2.5cm, image("images/arrow-left-up.png"))
    #place(top + left, dy: 0.4cm, dx: 0.8cm, box(
      fill: primary-container.transparentize(40%),
      width: 5.2cm,
      inset: (y: 8pt, x: 5pt),
      radius: 25pt,
      align(center, text(size: 8.5pt)[Dominant fibre-fermenting phyla supporting SCFA production.]),
    ))
    #place(center + horizon, dx: -4cm, dy: 2.2cm, image("images/arrow-left-down.png"))
    #place(bottom + left, dy: 0.2cm, dx: 0.2cm, box(
      fill: primary-container.transparentize(40%),
      width: 6.5cm,
      inset: (y: 8pt, x: 8pt),
      radius: 25pt,
      align(center, text(
        size: 8.5pt,
      )[Elevated levels may indicate dysbiosis and increased abundance of Gram-negative bacteria capable of producing inflammatory endotoxins (LPS).]),
    ))
  ]
  #v(0.5cm)
  #let magenta = rgb("e743a8")
  #let banana = rgb("ffde59")
  #let cyan = rgb("0cc0df")
  #align(center, box(width: 85%, {
    set par(spacing: 0pt)

    box(
      width: 100%,
      height: 1cm,
    )[
      #let slider-tab(label, value) = place(center + bottom, dx: value * 1% - 50%, box[
        *#label*
        #v(0.3em)
        #image("images/slider-arrow.svg")
      ])
      #slider-tab("Diversity", report.at_a_glance.diversity)
      #slider-tab("Richness", report.at_a_glance.richness)
      #slider-tab("Balance*", report.at_a_glance.balance)
    ]
    box(
      fill: gradient.linear(space: oklch, (magenta, 0%), (banana, 30%), (cyan, 50%), (banana, 70%), (magenta, 100%)),
      width: 100%,
      height: 1.5em,
      radius: 50%,
    )[
      #let text-box(txt) = box(width: 33%, align(center, text(size: 12pt, fill: rgb("164a64"))[*#txt*]))
      #place(start + horizon, text-box[Lower Deviation])
      #place(center + horizon, text-box[Acceptable Range])
      #place(end + horizon, text-box[Upper Deviation])
    ] // TODO:
    box(width: 100%, align(left, text(
      size: 7pt,
    )[\*Balance reflects distribution across microbial species and may differ from phyla-level patterns shown above]))
  }))

  #align(center, stack(
    stack(dir: ltr, spacing: 0.5cm, comment-card("What's Good", report.at_a_glance.comments_good), comment-card(
      "What's Missing",
      report.at_a_glance.comments_missing,
    )),
    v(0.5cm),
    stack(
      stack(
        dir: ltr,
        spacing: 0.5cm,
        comment-card("What's Harmful / Risks", report.at_a_glance.comments_risks),
        comment-card(
          "Actionable Next Steps",
          report.at_a_glance.comments_next_steps,
        ),
      ),
    ),
  ))
]
