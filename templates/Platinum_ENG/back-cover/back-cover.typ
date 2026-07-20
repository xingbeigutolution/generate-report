#import "../lib.typ": *

#let contact-line(img: none, body) = box(stack(
  dir: ltr,
  if img != none { image(img, height: 1em) },
  h(0.5em),
  align(horizon, body),
))

#let back-cover(_) = page(
  fill: gradient.linear(space: oklch, angle: 0deg, rgb("cae7ed"), rgb("61bbcb")),
  numbering: none,
  margin: (x: 2cm, y: 1.5cm)
)[
  #align(bottom + center)[
    #set par(leading: 0.4em, spacing: 1em)
    #set text(
      size: 12pt,
      tracking: 0.25pt,
    )

    #image("images/gutolution-logo-tagline.png", width: 9.3cm)

    GUTolution Limited

    #box(width: auto, align(left)[
      #contact-line(img: "images/whatsapp.svg")[(+852) 5726 2664]\
      #contact-line(img: "images/email.svg")[info\@gutolution.com]\
      #contact-line(img: "images/web.svg")[www.gutolution.com]
    ])

    #v(0.7cm)

    #text(size: 25pt, weight: 450)[
      #set par(spacing: 0.7em)
      GUTolution™ Microbiome Test

      Platinum
    ]

    #align(left, par(justify: true, text(size: 10pt, weight: 450, tracking: 0pt, [_The information on this report is for educational and informational use only. The information is not intended to be used by the customer for any diagnostic purpose and is not a substitute for professional medical advice. You should always seek the advice of your physician or other healthcare providers with any questions you may have regarding diagnosis, cure, treatment, mitigation, or prevention of any disease or other medical condition or impairment or the status of your health._])))
  ]
]
