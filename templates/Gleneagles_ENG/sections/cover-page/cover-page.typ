#import "../../lib.typ": *

#let cover-page(report) = page(background: align(bottom, image("images/cover-page-background.png")), margin: (
  x: 0.6in,
))[
  #if display-logo {
    image("images/gleneagles-logo-full.jpg", width: 400pt)
  }
  #v(7em)
  #title()
  #v(5em)
  #block(width: 55%)[
    #subtitle[
      #columns(2, gutter: 0pt)[
        #set par(spacing: 1.5em)
        User Name:

        Report ID:

        Report Date:
        #colbreak()
        #report.report_information.user_full_name

        #report.report_information.report_id

        #report.report_information.date_of_report.display(date-format)
      ]
    ]
  ]
]
