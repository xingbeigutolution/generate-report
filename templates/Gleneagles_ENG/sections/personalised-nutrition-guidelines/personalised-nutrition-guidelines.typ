#import "../../lib.typ": *

#let personalised-nutrition-guidelines(section, report) = page[
  #section-heading[#i18n.at(section).zh_HK\ #section]

  #let food-categories = yaml("food-categories.yaml")
  #let recommendations = report.food_recommendations

  #let food-recommendation(title: [], category: "") = [
    #pad(top: 1em, align(center, text(fill: secondary.darken(30%), weight: "extrabold", size: 20pt, title)))
    #set text(size: 14pt)
    #set par(justify: false)
    #let tier-pill(tier: "Superfood") = box(
      radius: 50%,
      fill: primary.lighten(10%),
      inset: 0.5em,
      width: 5em,
      align(center + horizon, text(
        fill: white,
        size: 11pt,
      )[#tier]),
    )
    #let number-of-recommendations(category, tier) = (
      food-categories.at(category).filter(food => recommendations.at(food, default: "") == tier).len()
    )
    #let recommendations-aggregate(category, tier) = align(horizon, stack(dir: ltr, [#tier: ], pad(x: 8pt, circle(
      fill: primary.lighten(20%),
      radius: 14pt,
      stroke: none,
      text(weight: "bold", [#number-of-recommendations(category, tier)]),
    ))))
    #align(center, stack(
      dir: ltr,
      spacing: 3em,
      recommendations-aggregate(category, "Superfood"),
      recommendations-aggregate(category, "Enjoy"),
      recommendations-aggregate(category, "Minimize"),
    ))
    #align(center, grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 1em,
      ..food-categories
        .at(category)
        .map(food => {
          grid(
            columns: (auto, 6pt, 1fr),
            align: horizon,
            image("images/" + lower(food) + ".png"),
            [],
            box(height: 45pt, align(bottom, stack(
              text(size: if food.len() > 14 { 10pt } else { 14pt })[#par(leading: 0.4em, food)],
              v(0.5em),
              tier-pill(tier: recommendations.at(food)),
            ))),
          )
        })
    ))
  ]

  #food-recommendation(
    title: [蔬菜\ Vegetables],
    category: "vegetables",
  )
  #pagebreak()
  #food-recommendation(
    title: [蛋白質與脂肪\ Proteins and Fats],
    category: "proteins_fats",
  )
  #pagebreak()
  #food-recommendation(
    title: [生果與穀物\ Fruit and Grains],
    category: "fruits_grains",
  )
  #pagebreak()
  #food-recommendation(
    title: [香料\ Spices],
    category: "spices",
  )
]
