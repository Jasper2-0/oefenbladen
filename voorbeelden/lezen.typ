// Voorbeeld lezen groep 3 (Veilig Leren Lezen, KIM-versie): een leesblad
// voor kern 3. De woorden komen uit methoden/vll/kernen.yaml: vooral van
// kern 3, aangevuld met eerdere kernen.
#import "/vakken/lezen/lezen.typ": *
#let kernen = yaml("/methoden/vll/kernen.yaml")

#show: oefenbladen.with(groep: 3, label: "Lezen", thema: "kern 3", soort: "Leesblad")

#werkblad(1, [Elke dag 1 minuut lezen], soort: "Leesblad")
#leesblad(kernen, "3", seed: 3)

#werkblad(2, [Rol en lees], soort: "Spel")
#rolenlees(kernen, "3", seed: 3)
