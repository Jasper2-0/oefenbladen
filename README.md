# Oefenbladen

Printbare oefenbladen voor de basisschool, aansluitend bij de lesmethodes,
gezet met [Typst](https://typst.app).

Het project heeft drie delen:

| Deel | Map | Wat |
| --- | --- | --- |
| Programma | `prive/` (niet in deze repo) | Wat een klas nu doet, uit de weekberichten van school; levert briefings op. |
| Methoden | `methoden/` | De opzet van de methodes, uit openbare bronnen. |
| Generator | `kern/`, `vakken/`, `fonts/` | Maakt van een briefing een printbaar blad. |

## Methoden en vakken

| Vak | Methode | Functies | Gegevens |
| --- | --- | --- | --- |
| Lezen groep 3 | Veilig Leren Lezen (KIM) | `vakken/lezen/lezen.typ`: leesblad, rol en lees | `methoden/vll/kernen.yaml` |
| Schrijven | Pennenstreken | `vakken/schrijven/schrijven.typ`: lineatuur, naschrijven | `methoden/pennenstreken/` |
| Taal en spelling | Staal | `vakken/taal/taal.typ`: spelling, woordkaartjes, bingo, woordzoeker | `methoden/staal/regelkaart-groep-4.yaml` |
| Rekenen | De wereld in getallen 5 | `vakken/rekenen/rekenen.typ`: getallenlijn, rekenrek, geld, sommen | nog niet openbaar vastgelegd |

## Een blad maken

Een briefing is een Typst-bestand dat het vakbestand importeert en de
functies aanroept met de inhoud van dat moment, bijvoorbeeld:

```typst
#import "/vakken/lezen/lezen.typ": *
#let kernen = yaml("/methoden/vll/kernen.yaml")
#show: oefenbladen.with(label: "Lezen", thema: "kern 4", soort: "Leesblad")
#werkblad(1, [Elke dag 1 minuut lezen], soort: "Leesblad")
#leesblad(kernen, "4", seed: 4)
```

Compileer vanuit de projectmap:

```bash
typst compile --root . --font-path fonts pad/naar/briefing.typ blad.pdf
```

Lettertypen: Avenir en Futura (macOS), Nexa Heavy en Lusletters (`fonts/`).
