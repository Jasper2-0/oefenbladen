// Voorbeeld spelling groep 4 (Staal). Het regelkader toont nummer en naam
// uit methoden/staal/regelkaart-groep-4.yaml. Heb je de regelkaart, geef de
// regelzinnen dan mee: #regels-van(tekst: yaml("..."), "hakwoord", ...).
// Zie methoden/staal/README.md.
#import "/vakken/taal/taal.typ": *

#show: oefenbladen.with(groep: 4, thema: "Voorbeeld", soort: "Spelling")

#werkblad(1, [Luchtwoord en plankwoord], soort: "Spellingblad")

#opdracht(1, [Dit zijn de regels],
  instructie: [Lees de regels samen. Zeg ze hardop.],
)[
  #regels-van("luchtwoord", "plankwoord")
]

#opdracht(2, [Woorden met cht],
  instructie: [Lees de zin. Schrijf *cht* op de streep.],
)[
  #voorbeeld[De boot vaart door de gra#gat(tekst: "cht").]
  #zinnen(
    [Het is midderna#gat().],
    [Doe het li#gat() aan, het is donker.],
    [Doe het raam open, ik wil frisse lu#gat().],
  )
]

#opdracht(3, [Woorden met nk],
  instructie: [Lees de zin. Schrijf *nk* op de streep. Daar mag geen g tussen.],
)[
  #voorbeeld[Mijn pi#gat(tekst: "nk") is mijn kleinste vinger.]
  #zinnen(
    [Ik zit op de ba#gat().],
    [De boot zi#gat() naar de bodem.],
    [Wij dri#gat()en limonade.],
  )
]

#opdracht(4, [Dictee],
  instructie: [Je vader of moeder leest de woorden en de zin voor. Schrijf ze op.],
)[
  #dictee(woorden: 6, zinnen: 1, voorbeeld: ("zacht", 3))
]
