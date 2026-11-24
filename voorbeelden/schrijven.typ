// Voorbeeld schrijven groep 3 (Pennenstreken): letterbladen voor kern 2.
// De woorden komen uit methoden/vll/kernen.yaml, met alleen letters die het
// kind al gehad heeft. `extra` en `zin` schrijf je zelf; letterblad geeft een
// fout als daar een letter in staat die nog niet aan de beurt was.
// Print op 100%, anders klopt de lineatuur niet.
#import "/vakken/schrijven/schrijven.typ": *
#let kernen = yaml("/methoden/vll/kernen.yaml")

#show: oefenbladen.with(groep: 3, label: "Schrijven", thema: "kern 2", soort: "Schrijfblad")

#letterblad(1, kernen, "2", "n", zin: "ik ren naar sim.")
#letterblad(2, kernen, "2", "b", extra: ("bes", "beer"), zin: "ik eet een bes.")
