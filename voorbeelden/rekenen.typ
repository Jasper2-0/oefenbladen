// Voorbeeld rekenen groep 4: sprongen van 10, via de 10 en geld.
// De functies rekenen de antwoorden zelf uit. Antwoordblad:
//   typst compile --root . --font-path fonts --input oplossing=ja voorbeelden/rekenen.typ antwoorden.pdf
#import "/vakken/rekenen/rekenen.typ": *

#show: oefenbladen.with(groep: 4, label: "Rekenen", thema: "voorbeeld",
  soort: if oplossing { "Antwoorden" } else { "Werkblad" })

#werkblad(1, [Sprongen van 10])

#opdracht(1, [Spring met 10],
  instructie: [Teken de sprongen op de getallenlijn. Waar kom je uit?])[
  #rekenvoorbeeld[#sprongen(20, 2)]
  #sprongen(12, 3)
]

#opdracht(2, [10 minder en 10 meer],
  instructie: [Alleen het tiental verandert.])[
  #meerminder(voorbeeld: 52, 24, 57, 81)
]

#werkblad(2, [Via de 10])

#opdracht(1, [Eerst naar de 10],
  instructie: [Reken in 2 stappen. Eerst naar de 10, dan de rest. Het rekenrek laat het eerste getal zien.])[
  #viade10-voorbeeld((8, "+", 5), (13, "-", 5))
  #viade10(14, "-", 6, rek: true)
]

#opdracht(2, [Reken uit],
  instructie: [Denk aan de 10.])[
  #sommen(kolommen: 3, (9, "+", 5), (6, "+", 8), (13, "-", 7))
]

#werkblad(3, [Geld])

#opdracht(1, [Hoeveel is het samen?],
  instructie: [Tel eerst de briefjes, dan de munten.])[
  #rekenvoorbeeld[#hoeveel(nummers: false, (20, 5, 2))]
  #hoeveel((20, 10, 2), (50, 5, 2, 1))
]

#opdracht(2, [Zo min mogelijk geld],
  instructie: [Schrijf in elk vakje hoeveel briefjes of munten je nodig hebt. Niet nodig? Laat het vakje leeg.])[
  #zominmogelijk(voorbeeld: 34, 37, 64)
]
