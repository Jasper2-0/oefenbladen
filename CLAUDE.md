# Oefenbladen met Typst

Printbare oefenbladen voor de basisschool (nu groep 3 en 4), aansluitend bij
de lesmethodes. Het project heeft drie delen:

1. **Programma** (`prive/`, alleen lokaal): wat een klas nu doet en wat een
   kind nodig heeft, afgeleid uit de weekberichten (Parro) en het materiaal
   van de leerkracht. Levert briefings op: de bladbestanden in
   `prive/groep-<n>/<vak>/<blok>/`. **Lees `prive/CLAUDE.md` als die map
   bestaat.** Niets uit `prive/` mag in deze repo of op GitHub terechtkomen;
   de map staat in `.gitignore` en heeft een eigen git zonder remote.
2. **Methoden** (`methoden/`): de opzet van de methodes, alleen afgeleid uit
   openbare bronnen. Zie `methoden/README.md` voor wat daar mag staan.
3. **Generator** (`kern/`, `vakken/`, `fonts/`): de opmaak en functies die van
   een briefing een blad maken.

Materiaal hoort bij een groep, niet bij een kind: wat nu voor groep 4 is
gemaakt, kan een kind een jaar later opnieuw gebruiken.

## Mappen

- `kern/opmaak.typ` : opmaak voor alle vakken (pagina, kop, opdrachtblok,
  voorbeeld, schrijflijnen, kiezen/koppelen, lezen, ouderbladen, hussel).
- `vakken/<vak>/<vak>.typ` : functies per vak. Importeert de kern, dus een
  bladbestand importeert alleen zijn vakbestand.
  - `vakken/taal/taal.typ` : Staal (spelling, woordenlijst, woordkaartjes,
    bingo, woordzoeker).
  - `vakken/rekenen/rekenen.typ` : De wereld in getallen (getallenlijn,
    rekenrek, geld, sommen).
  - `vakken/schrijven/schrijven.typ` : Pennenstreken (Lusletters, lineatuur).
  - `vakken/lezen/lezen.typ` : Veilig Leren Lezen groep 3 (leesblad,
    rol en lees).
- `methoden/<methode>/` : gegevens per methode, met bronnen.
- `fonts/` : Nexa Heavy (koppen) en Lusletters (schrijven). Niet in git;
  `sh fonts/ophalen.sh` haalt ze op.

## Vormgeving (alle vakken)

- A4 staand, ruime marges, geschikt voor zwart-wit printen.
- Lettertype: Avenir (systeemfont op macOS). Dat is ook de letter van de
  woordkaartjes van Staal, zodat het blad vertrouwd aanvoelt voor het kind.
  Book (400) voor gewone tekst, Heavy (800) voor vet; Avenir heeft geen 700.
  Titels en koppen in Nexa Heavy (`fonts/Nexa-Heavy.ttf`, gratis voor privégebruik, van
  Fontfabric). Tekst voor het kind minimaal 14 pt met ruime regelafstand.
  Groep 3: wat het kind leest in Futura (systeemfont op macOS, met de
  schoolschrift-a en -g zoals in Veilig Leren Lezen), minimaal 22 pt.
  Schrijven (alle groepen): Lusletters, zie `methoden/pennenstreken/README.md`.
- Bovenaan elk werkblad: groep, titel, thema of blok, "Naam:" en "Datum:".
  De groep staat ook in een vakje rechtsboven en in de voettekst
  (`oefenbladen.with(groep: 4, ...)`), zodat geprinte bladen van
  verschillende groepen niet door elkaar raken.
- Elk werkblad begint op een nieuwe pagina. Een opdracht loopt nooit over een
  paginagrens.
- Elke opdracht is een afgebakend blok: nummer, korte instructie, eventueel een
  voorbeeld in een licht kader.
- Vraagt een opdracht om visuele verwerking (tekenen, een pijl of sprong
  zetten, iets in een plaatje, schema of vakjes invullen), dan is het
  voorbeeld ook visueel: hetzelfde plaatje of dezelfde vakjes, al ingevuld.
  Een voorbeeld in woorden alleen is dan niet genoeg. Zo'n voorbeeld is een
  functie in `kern/` of `vakken/`, niet losse opmaak in het blad: de
  parameter `voorbeeld:` van een opdrachtfunctie (goedfout, volgorde,
  leesteken, samenstelling, tegendeel, sorteren, langermaken, dictee,
  koppeltabel, meerminder, zominmogelijk), `tekst:` van invul, gat en vakje
  en `goed:` van kies en meerkeuze in een `voorbeeld[...]`, en bij rekenen
  `rekenvoorbeeld[...]` om dezelfde functie heen of `viade10-voorbeeld`. Gebruik in het voorbeeld geen som of woord uit de opdracht zelf.
- Schrijflijnen: echte lijnen, regelhoogte ongeveer 1,2 cm.
- Voettekst: groep, thema of blok, werkbladnummer, paginanummer.
- Rustig en kindvriendelijk, geen overdaad.
- Geen logo's, huisstijl of opmaak van de uitgevers overnemen. Geen plaatjes
  van internet; tekeningen (getallenlijn, geld) maken we zelf in Typst.

## Inhoud

- Alleen actuele inhoud van de methode die de school nu gebruikt. Geen oude
  of mogelijk verouderde versies van uitgeversmateriaal.
- Oefen alleen wat de klas al gehad heeft. Het nieuwe van het blok krijgt de
  meeste aandacht.

## Techniek

- Controleer eerst `typst --version` en gebruik syntax die bij die versie hoort.
  Raadpleeg de Typst-documentatie bij twijfel.
- Opmaak hoort in `kern/` of `vakken/`, nooit in de bladbestanden.
  Een functie die meer vakken nodig hebben, hoort in de kern.
- Compileer vanuit de projectmap met `--root .` en `--font-path fonts`,
  bijvoorbeeld:
  `typst compile --root . --font-path fonts prive/groep-4/taal/kleding/werkbladen.typ prive/uit/groep-4/taal/blok-2-kleding/werkbladen.pdf`
- Geen externe packages tenzij echt nodig; meld het als je er een gebruikt.
- Twee git-repo's: deze (generator en methoden, op GitHub) en `prive/`
  (lokaal). Commit na een afgeronde stap als de gebruiker daarom vraagt, in
  de repo waar de wijziging hoort. Controleer voor elke commit in deze repo
  dat er niets uit `prive/` of over een kind, klas of leerkracht in staat.

## Controleren voor je klaar bent

- Alles compileert zonder fouten of waarschuwingen.
- Exporteer de pagina's ook als png en bekijk ze zelf: niets buiten de marge,
  geen opdracht over een paginagrens, lijnen en vakjes groot genoeg.
- Elke opdracht heeft precies een goed antwoord en dat staat in de antwoorden.
- Verander je iets in `kern/`, controleer dan dat de bladen van de andere
  vakken er nog precies hetzelfde uitzien.
- Meld kort wat je hebt gemaakt en wat je hebt aangepast ten opzichte van de
  bron.
