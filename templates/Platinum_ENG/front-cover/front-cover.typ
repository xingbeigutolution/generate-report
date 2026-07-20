#import "../lib.typ": *

#let front-cover(report) = page(
  background: image("../images/background-pattern.svg"),
  margin: (x: 1cm, top: 1cm, bottom: 0cm),
  align(center)[
    #image("images/gutolution-logo-tagline.svg")
    #v(1em)
    #box(title()) // Hack: remove space before title
    #v(0.2cm)
    #image("images/arrow-logo.svg")
    #v(0.2cm)
    #{
      set text(features: ("cv05",))
      show table.cell.where(x: 0): set text(weight: "bold")
      show table.cell: set text(size: 19pt, fill: rgb("164A64"))
      box(width: 13cm, table(
        columns: (50%, 50%),
        rows: 3.2em,
        align: left + horizon,
        inset: (y: 0.5em),
        stroke: gray.lighten(40%),
        fill: white,
        [Client Name:], [#report.client.name],
        [Sample Received:], [#report.sample_collected_date.display(date-format)],
        [Testing Package:], [#report.product],
        [DOB:], [#report.client.date_of_birth.display(date-format)],
        [Sample ID:], [#report.sample_id],
        [Report No.:], [#report.report_id],
        [Gender:], [#report.client.gender],
      ))
    }

    #par(spacing: 2em)[
      GUTolution Limited | (+852) 5726 2664 (WhatsApp)\
      info\@gutolution.com | www.gutolution.com
    ]
  ],
)
