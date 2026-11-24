// Lezen groep 3 (Veilig Leren Lezen, KIM-versie). Bevat ook alles uit
// kern/opmaak.typ.
//
// De woorden komen uit methoden/vll/kernen.yaml (overgenomen van de
// doelkaarten). Een blad voor kern n gebruikt vooral woorden van kern n en
// vult aan met woorden van de kernen ervoor: alleen wat de klas al gehad heeft.
//
// Leesletter: Futura (systeemfont op macOS), omdat die de schoolschrift-a en
// -g heeft (enkele a, zoals in de leesboekjes). Avenir heeft een dubbele a.

#import "/kern/opmaak.typ": *

#let leesletter = "Futura"

// De volgorde van de kernen in kernen.yaml.
#let _volgorde = ("start", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11")

#let _uniek(lijst) = {
  let uit = ()
  for x in lijst { if x not in uit { uit.push(x) } }
  uit
}

// Geeft een duidelijke fout als kern k niet in kernen.yaml staat.
#let _kern(kernen, k) = assert(k in kernen,
  message: "Onbekende kern \"" + k + "\". Kies uit: " + kernen.keys().join(", ") + " (zonder \"kern\" ervoor).")

// Alle woorden van één kern, zonder dubbele.
#let _woorden(kernen, k) = _uniek(kernen.at(k).woordjes + kernen.at(k).oefen)

// De kernen vóór kern k.
#let _eerder(k) = _volgorde.slice(0, _volgorde.position(x => x == k))

// `aantal` woorden: zoveel mogelijk (tot `nieuw`) van kern k, de rest van de
// kernen ervoor. Gehusseld met een vaste seed.
#let kernwoorden(kernen, k, aantal: 40, nieuw: 24, seed: 1) = {
  _kern(kernen, k)
  let eigen = hussel(_woorden(kernen, k), seed)
  let n = calc.min(nieuw, eigen.len())
  let oud = hussel(
    _uniek(_eerder(k).map(e => _woorden(kernen, e)).flatten()).filter(w => w not in eigen),
    seed + 17,
  )
  let keuze = eigen.slice(0, n) + oud.slice(0, calc.min(aantal - n, oud.len()))
  hussel(keuze, seed + 31)
}

#let _lees(body, size: 24pt) = text(font: leesletter, weight: 500, size: size, body)

// ---------------------------------------------------------------------------
// Leesblad: elke dag 1 minuut lezen
// ---------------------------------------------------------------------------

// Woorden in `kolommen` kolommen, van boven naar beneden te lezen per rij,
// en onderaan rondjes om de score van elke dag in te schrijven.
#let leesblad(kernen, k, aantal: 40, nieuw: 24, kolommen: 5, dagen: 10, seed: 1) = {
  _kern(kernen, k)
  let woorden = kernwoorden(kernen, k, aantal: aantal, nieuw: nieuw, seed: seed)
  opdracht(1, [Lees zo veel woordjes als je kunt],
    instructie: [Lees elke dag 1 minuut, rij voor rij. Je vader of moeder kijkt op de klok. Hoeveel woordjes heb je gelezen? Schrijf het in het rondje van die dag.],
  )[
    #block(width: 100%, inset: (x: 12pt, y: 14pt), stroke: 1pt + lijnkleur, radius: 8pt,
      grid(
        columns: (1fr,) * kolommen,
        row-gutter: 0.8cm,
        ..woorden.map(w => _lees(w)),
      ),
    )
    #v(0.5cm)
    #grid(
      columns: (1fr,) * dagen,
      ..range(dagen).map(d => align(center, stack(
        spacing: 4pt,
        circle(radius: 0.62cm, stroke: 1pt + lijnkleur),
        text(size: 10pt, fill: zacht)[dag #(d + 1)],
      ))),
    )
  ]
}

// ---------------------------------------------------------------------------
// Rol en lees: dobbelspel met letters en woorden
// ---------------------------------------------------------------------------

// Een dobbelsteen met `n` ogen (1 t/m 6).
#let dobbelsteen(n, maat: 0.95cm) = {
  let p = maat / 4
  let posities = (
    (2, 2),
    ((1, 1), (3, 3)),
    ((1, 1), (2, 2), (3, 3)),
    ((1, 1), (3, 1), (1, 3), (3, 3)),
    ((1, 1), (3, 1), (2, 2), (1, 3), (3, 3)),
    ((1, 1), (3, 1), (1, 2), (3, 2), (1, 3), (3, 3)),
  ).at(n - 1)
  if n == 1 { posities = (posities,) }
  box(width: maat, height: maat, radius: 18%, stroke: 1pt, {
    for (x, y) in posities {
      place(top + left, dx: x * p - 0.09cm, dy: y * p - 0.09cm, circle(radius: 0.09cm, fill: black))
    }
  })
}

// Zes rijen, één per aantal ogen. `items`: precies 6 * per-rij teksten.
#let _rooster(items, per-rij, size) = table(
  columns: (1.4cm,) + (1fr,) * per-rij,
  rows: 1.05cm,
  align: center + horizon,
  stroke: 0.8pt + lijnkleur,
  ..range(6).map(r => (
    dobbelsteen(r + 1),
    ..items.slice(r * per-rij, (r + 1) * per-rij).map(x => _lees(x, size: size)),
  )).flatten(),
)

// Letters: de nieuwe letters van kern k elk `keer` keer, aangevuld met
// letters van de kernen ervoor.
#let _kernletters(kernen, k, aantal, keer, seed) = {
  let eigen = kernen.at(k).letters
  let oud = _eerder(k).map(e => kernen.at(e).letters).flatten()
  let lijst = ()
  for _ in range(keer) { lijst += eigen }
  let i = 0
  let pool = hussel(oud, seed + 5)
  while lijst.len() < aantal and pool.len() > 0 {
    lijst.push(pool.at(calc.rem(i, pool.len())))
    i += 1
  }
  hussel(lijst.slice(0, aantal), seed + 9)
}

#let rolenlees(kernen, k, seed: 1) = {
  _kern(kernen, k)
  let spelregel = [Speel met z'n tweeën. Gooi de dobbelsteen en lees een letter uit de rij met evenveel ogen. Goed gelezen? Kruis hem door. Wie heeft als eerste een hele rij?]
  if kernen.at(k).letters.len() > 0 {
    opdracht(1, [Rol en lees: letters], instructie: spelregel)[
      #_rooster(_kernletters(kernen, k, 48, 3, seed), 8, 22pt)
    ]
  }
  opdracht(2, [Rol en lees: woorden], instructie: [Zelfde spel, nu met woorden.])[
    #_rooster(kernwoorden(kernen, k, aantal: 30, nieuw: 20, seed: seed + 50), 5, 20pt)
  ]
}
