# Oefenbladen

Printbare oefenbladen voor de basisschool, aansluitend bij de lesmethodes,
gezet met [Typst](https://typst.app).

Het project heeft drie delen:

| Deel | Map | Wat |
| --- | --- | --- |
| Programma | `prive/` (niet in deze repo) | Wat een klas nu doet, uit de weekberichten van school; levert briefings op. |
| Methoden | `methoden/` | De opzet van de methodes, uit openbare bronnen. |
| Generator | `kern/`, `vakken/`, `fonts/` | Maakt van een briefing een printbaar blad. |

## Aan de slag

1. Installeer [Typst](https://typst.app) 0.15 of nieuwer, op een Mac
   bijvoorbeeld met `brew install typst`.
2. Clone deze repo en ga naar de map.
3. Haal de lettertypen op (eenmalig):

   ```bash
   sh fonts/ophalen.sh
   ```

4. Maak een voorbeeldblad:

   ```bash
   sh maak.sh voorbeelden/rekenen.typ
   sh maak.sh voorbeelden/rekenen.typ antwoorden
   ```

   De pdf komt naast het bestand: `voorbeelden/rekenen.pdf` en
   `voorbeelden/rekenen-antwoorden.pdf`.
5. Maak je eigen bladen in de map `prive/`. Die staat in `.gitignore` en gaat
   dus nooit mee naar GitHub. Kopieer een voorbeeld, pas de inhoud aan en maak
   de pdf:

   ```bash
   mkdir -p prive
   cp voorbeelden/rekenen.typ prive/rekenen-week-1.typ
   sh maak.sh prive/rekenen-week-1.typ
   ```

In [`voorbeelden/README.md`](voorbeelden/README.md) staat per vak wat je kunt
aanpassen. Print op 100% (werkelijke grootte), zeker bij schrijfbladen.

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

Maak de pdf met `sh maak.sh pad/naar/briefing.typ`, of met Typst zelf
vanuit de projectmap:

```bash
typst compile --root . --font-path fonts pad/naar/briefing.typ blad.pdf
```

Zonder `--root .` vindt Typst de imports (`/vakken/...`) niet.

## Lettertypen

Avenir en Futura zijn systeemfonts van macOS. Nexa Heavy (koppen) en
Lusletters (schrijfletter) staan niet in deze repo; haal ze eerst op:

```bash
sh fonts/ophalen.sh
```

Het script downloadt ze van de makers (Nexa Heavy via DaFont, gratis voor
privégebruik; Lusletters van syboor.eu, SIL Open Font License) en controleert
ze met een checksum. Op Windows of Linux ontbreken Avenir en Futura; Typst
kiest dan een ander lettertype en geeft een waarschuwing.
