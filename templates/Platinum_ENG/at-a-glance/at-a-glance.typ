#import "../lib.typ": *

#let header = context {
  align(bottom)[
    #place(top + start, pad(top: 0em, left:0em, text(size: 22pt, weight: "extrabold", fill:rgb(22,74,100))[#h(1cm) At a glance..]))
    ]
}

#let at-a-glance(report) = page(background: standard-page-background(section-header: [#header]))[

]
