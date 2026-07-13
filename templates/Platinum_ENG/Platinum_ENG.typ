#import "lib.typ": *
#import "cover-page/cover-page.typ": cover-page
#import "at-a-glance/at-a-glance.typ": at-a-glance
#import "pathogen-opportunistic-bacteria/pathogen-opportunistic-bacteria.typ": pathogen-opportunistic-bacteria
#import "intestinal-health-markers/intestinal-health-markers.typ": intestinal-health-markers
#import "microbial-ecosystem/microbial-ecosystem.typ": microbial-ecosystem
//#import "pie/pie.typ": pie

#set document(
  title: [GUTolution™ Microbiome Test Platinum],
)

#let production = sys.inputs.at("production", default: false)
#let report = if production { json(sys.inputs.at("input_json")) } else { json("reference/MEJAN8702_platinum_report_DEMO_FAKE_CLIENT.json") }
#{
  report.sample_collected_date = to-date(report.sample_collected_date)
  report.client.date_of_birth = to-date(report.client.date_of_birth)
}

#show: style

#cover-page(report)

#counter(page).update(2)

#show: page-style

#let sections = (at-a-glance, pathogen-opportunistic-bacteria, intestinal-health-markers, microbial-ecosystem)

#for (i, section) in sections.enumerate() {
  section(report)
  if i != sections.len() - 1 { pagebreak() }
}
