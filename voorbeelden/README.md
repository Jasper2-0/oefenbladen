# Voorbeelden

Eén voorbeeldblad per vak. Alles is zelf verzonnen, behalve de letters en
woorden van Veilig Leren Lezen (uit `methoden/vll/kernen.yaml`). Maak een pdf
met (vanuit de projectmap):

```bash
sh maak.sh voorbeelden/rekenen.typ
```

Bij elk voorbeeld staat de pdf die eruit komt, zodat je het hele pad van
invoer naar blad kunt zien zonder Typst te installeren. Na een wijziging in
`kern/` of `vakken/` maak je ze allemaal opnieuw met:

```bash
for f in voorbeelden/*.typ; do sh maak.sh "$f"; done; sh maak.sh voorbeelden/rekenen.typ antwoorden
```

Wil je een blad aanpassen? Kopieer het naar `prive/` (staat in `.gitignore`)
en verander alleen de inhoud: getallen, kern, letters, woorden. De opmaak zit
in `kern/` en `vakken/`; daar hoef je niets aan te doen.

| Bestand → resultaat | Vak | Laat zien | Wat pas je aan |
| --- | --- | --- | --- |
| [`lezen.typ`](lezen.typ) → [pdf](lezen.pdf) | Lezen groep 3 (Veilig Leren Lezen, KIM) | Leesblad (1 minuut lezen) en rol-en-lees-spel | De kern: `"start"`, `"1"` … `"11"` (zonder "kern"); `seed` voor een andere volgorde |
| [`schrijven.typ`](schrijven.typ) → [pdf](schrijven.pdf) | Schrijven groep 3 (Pennenstreken) | Per letter: groot overtrekken, op de lijn, woorden en een zinnetje | Kern en letter; `zin` en `extra` (eigen woorden). Een woord met een letter die nog niet gehad is, geeft een fout |
| [`rekenen.typ`](rekenen.typ) → [pdf](rekenen.pdf), [antwoorden](rekenen-antwoorden.pdf) | Rekenen groep 4 | Sprongen van 10, rekenen via de 10, geld; antwoordblad met `sh maak.sh voorbeelden/rekenen.typ antwoorden` | De getallen. De antwoorden rekent het blad zelf uit |
| [`spelling.typ`](spelling.typ) → [pdf](spelling.pdf) | Spelling groep 4 (Staal) | Regelkader, invulzinnen, dictee | Categorieën en zinnen; zie hieronder voor de regelzinnen |
| [`woordenschat.typ`](woordenschat.typ) + [`woorden.yaml`](woorden.yaml) → [pdf](woordenschat.pdf) | Woordenschat | Woordenlijst en woordzoekers | De woorden in `woorden.yaml`; kopieer beide bestanden |
| [`woordkaartjes.typ`](woordkaartjes.typ) → [pdf](woordkaartjes.pdf) | Woordenschat | Kaartjes: voorkant woord, achterkant betekenis; dubbelzijdig printen | Gebruikt `woorden.yaml` |
| [`bingo.typ`](bingo.typ) → [pdf](bingo.pdf) | Woordenschat | Voorleeslijst en bingokaarten (4 × 4) | Gebruikt `woorden.yaml`; minstens 16 woorden |

## Regelzinnen van Staal

Het regelkader toont alleen nummer en naam van de categorie: de regelzinnen
zijn tekst van de uitgever en staan niet in deze repo. Heb je de regelkaart,
zet de zinnen dan in een eigen bestand, bijvoorbeeld `prive/regels.yaml`:

```yaml
hakwoord:
  regel: ["...de regelzin van de kaart..."]
```

en geef het mee:

```typst
#regels-van(tekst: yaml("regels.yaml"), "hakwoord", "zingwoord")
```

De namen van de categorieën staan in `methoden/staal/regelkaart-groep-4.yaml`.

## Woordenlijst (`woorden.yaml`)

Per woord: `woord`, `lidwoord` (`de`, `het` of `null`), `week`, `uitleg`,
`kaartje` (korte betekenis op het woordkaartje en in de bingo),
`voorbeeldzin`. Kopieer bij het aanpassen `woorden.yaml` mee naar dezelfde
map als je blad.

## Als het misgaat

- *file not found ... /vakken/...*: maak de pdf met `sh maak.sh`, of geef
  `--root .` mee vanuit de projectmap.
- *unknown font family: nexa*: draai `sh fonts/ophalen.sh`.
- *Onbekende kern / categorie / letter*: de melding zegt waaruit je kunt kiezen.
