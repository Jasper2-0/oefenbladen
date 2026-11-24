// Voorbeeld woordenschat: woordenlijst en woordzoeker uit woorden.yaml.
// Woordkaartjes en bingo werken met hetzelfde bestand:
//   #woordkaartjes(yaml("woorden.yaml"), thema: "Op de boerderij")
//   #bingo(yaml("woorden.yaml"), thema: "Op de boerderij", kaarten: 6)
#import "/vakken/taal/taal.typ": *
#let woorden = yaml("woorden.yaml")

#show: oefenbladen.with(thema: "Op de boerderij", soort: "Woordenschat")

#woordenlijst(woorden, 1)
#woordenlijst(woorden, 2)
#woordzoekers(woorden)
