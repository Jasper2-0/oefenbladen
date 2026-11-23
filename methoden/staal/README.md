# Staal (taal en spelling)

Taal- en spellingmethode van Malmberg, groep 4 t/m 8.

## `regelkaart-groep-4.yaml`

De spellingcategorieën van groep 4 met hun nummer en naam, zoals op de
regelkaart. Gebruik in een blad:

```typst
#import "/vakken/taal/taal.typ": *
#regels-van("hakwoord", "luchtwoord", "ei-ij")
```

- De **regelzinnen** en de **woordrijtjes** van de kaart staan hier niet: dat
  is tekst van Malmberg. Wie de kaart heeft, zet ze in een eigen yaml met
  dezelfde sleutels en geeft die mee:

  ```typst
  #regels-van(tekst: yaml("pad/naar/regelzinnen.yaml"), "hakwoord", "luchtwoord")
  ```

  ```yaml
  hakwoord:
    regel: ["..."]      # één item per regel op de kaart, zonder de naam ervoor
  ```

  Zonder `tekst` toont het kader alleen nummer en naam.
- Dit is de kaart van Staal (1), kaartnummer 540022, uit 2013/2014. Scholen
  kunnen een andere volgorde van categorieën per blok aanhouden; welk blok wat
  behandelt, hoort bij het programma, niet hier.

## Bron

Malmberg-ouderbrief "Staal | Ouderbrief spelling | Groep 4" (© Malmberg,
's-Hertogenbosch; pagina 2 en 3 zijn de regelkaart), openbaar gepubliceerd
door een basisschool:
<https://www.delouise.cnsede.nl/staal-spelling-groep-4>, geraadpleegd
23 november 2026.

## Nog niet vastgelegd

- Regelkaarten van groep 5 t/m 8.
- De volgorde van de categorieën per blok (staat op de registratiebladen van
  Malmberg; nagaan welke openbaar zijn).
