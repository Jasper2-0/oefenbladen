// Taal (Staal, groep 4 t/m 8): spelling, woordenlijst, woordkaartjes,
// woordenschatbingo en woordzoeker. Bevat ook alles uit kern/opmaak.typ,
// dus een taalbestand importeert alleen dit bestand.

#import "/kern/opmaak.typ": *

// ---------------------------------------------------------------------------
// Spelling (Staal-categorieën)
// ---------------------------------------------------------------------------

// Kader met de regels van de regelkaart. Elke rij: (nummer of none, naam, regelzin).
#let regels(..rijen) = block(
  width: 100%, fill: vlak, radius: 6pt, inset: (x: 12pt, y: 10pt),
  above: 0.2cm, below: 0.3cm,
  grid(
    columns: (1.4em, auto, 1fr),
    column-gutter: 8pt,
    row-gutter: 0.35cm,
    align: (center + top, left + top, left + top),
    ..rijen.pos().map(r => (
      if r.at(0) == none { [] } else { text(font: kopletter, weight: 900, str(r.at(0))) },
      strong(r.at(1)),
      r.at(2),
    )).flatten(),
  ),
)

// De regelkaart van een groep, uit methoden/staal/: nummer en naam per
// categorie. De regelzinnen zijn tekst van de uitgever en staan niet in de
// repo; wie de kaart heeft, geeft ze mee met `tekst:` (een yaml met dezelfde
// sleutels en per categorie een lijst `regel`).
#let regelkaart-groep-4 = yaml("/methoden/staal/regelkaart-groep-4.yaml")

// Kader met regels van de regelkaart, op naam van de categorie (de sleutels
// in de yaml), bijvoorbeeld `regels-van("hakwoord", "zingwoord", tekst: t)`.
// Elke regel van de kaart komt op een eigen regel; "1e" en "2e" krijgen een
// superscript. Zonder `tekst` alleen nummer en naam.
#let regels-van(kaart: regelkaart-groep-4, tekst: (:), ..namen) = {
  show regex("\b[12]e\b"): it => [#it.text.first()#super[e]]
  regels(..namen.pos().map(n => {
    assert(n in kaart, message: "Onbekende categorie \"" + n + "\". Kies uit: " + kaart.keys().join(", ") + ".")
    let c = kaart.at(n)
    let r = tekst.at(n, default: (:)).at("regel", default: ())
    (c.nummer, c.naam, r.join(linebreak()))
  }))
}

// Korte invulplek in een woord, voor een of twee letters.
#let gat(breedte: 1.3cm) = invul(breedte: breedte)

// Sorteren: kolommen met een kop en lege schrijflijnen.
#let sorteren(kolommen: (), rijen: 2) = table(
  columns: (1fr,) * kolommen.len(),
  inset: (x: 8pt, y: 0pt),
  stroke: (x, y) => (
    left: if x > 0 { 0.6pt + luma(150) } else { none },
    bottom: if y == 0 { 1pt + black } else { 0.7pt + lijnkleur },
  ),
  table.header(..kolommen.map(k => table.cell(inset: (x: 8pt, y: 7pt), strong(k)))),
  ..range(rijen * kolommen.len()).map(_ => block(height: regel)),
)

// Langermaakwoorden: het woord met een gat, en een lijn voor het lange woord.
#let langermaken(..woorden) = table(
  columns: (1.6em, 5.5cm, 1fr),
  align: (left + bottom, left + bottom, left + bottom),
  inset: (x: 4pt, y: 6pt),
  stroke: none,
  table.header(
    [], text(size: 11pt, fill: zacht)[Woord], text(size: 11pt, fill: zacht)[Langer],
  ),
  ..woorden.pos().enumerate().map(((i, w)) => (
    [#(i + 1).], block(height: 0.9cm, align(bottom, w)), lijn(),
  )).flatten(),
)

// Mini-dictee: genummerde schrijflijnen met een vakje voor het categorienummer,
// daarna lijnen voor de zin(nen).
#let dictee(woorden: 8, zinnen: 1) = {
  grid(
    columns: (1.6em, 1fr, 1.4cm),
    column-gutter: 8pt,
    row-gutter: 0.25cm,
    align: (left + bottom, left + bottom, right + bottom),
    text(size: 11pt, fill: zacht)[], text(size: 11pt, fill: zacht)[Woord], text(size: 11pt, fill: zacht)[Nummer],
    ..range(woorden).map(i => (
      [#(i + 1).],
      block(width: 100%, height: regel, stroke: (bottom: 0.7pt + lijnkleur)),
      box(width: 1cm, height: 1cm, radius: 3pt, stroke: 0.9pt + black),
    )).flatten(),
  )
  if zinnen > 0 {
    v(0.3cm)
    strong[Zin]
    schrijflijnen(aantal: zinnen * 2)
  }
}

// ---------------------------------------------------------------------------
// Woordenlijst (gegenereerd uit woorden.yaml)
// ---------------------------------------------------------------------------

#let _woordmetlidwoord(w) = if w.at("lidwoord", default: none) != none {
  [#w.lidwoord #strong(w.woord)]
} else {
  strong(w.woord)
}

// Een uitdrukking (veld `uitdrukking: true`) staat op de woordenlijst en de
// kaartjes, maar niet in de bingo en de woordzoeker.
#let _uitdrukking(w) = w.at("uitdrukking", default: false)
#let _zin(w) = w.at("voorbeeldzin", default: none)

#let woordenlijst(woorden, week) = {
  let deze = woorden.filter(w => w.week == week)
  let n = deze.filter(w => not _uitdrukking(w)).len()
  let u = deze.len() - n
  _bladkop([Woordenlijst week #week], [Woordenlijst week #week],
    [De #n woorden van week #week#if u == 1 [ en 1 uitdrukking] else if u > 1 [ en #u uitdrukkingen]], naam: false)
  table(
    columns: (5.6cm, 1fr, 1.15fr),
    inset: (x: 7pt, y: 8pt),
    align: left + top,
    stroke: (x, y) => (bottom: 0.6pt + luma(150)),
    table.header(
      text(size: 11pt, fill: zacht)[Woord],
      text(size: 11pt, fill: zacht)[Wat betekent het?],
      text(size: 11pt, fill: zacht)[Voorbeeldzin],
    ),
    ..woorden.filter(w => w.week == week).map(w => (
      _woordmetlidwoord(w), w.at("kaartje", default: w.uitleg), emph(_zin(w)),
    )).flatten(),
  )
}

// ---------------------------------------------------------------------------
// Woordkaartjes (gegenereerd uit woorden.yaml), dubbelzijdig afdrukken
// ---------------------------------------------------------------------------
//
// Per vel 10 kaartjes (2 kolommen x 5 rijen). Oneven pagina: woorden.
// Even pagina: de betekenis van de uitgever (veld `kaartje`) met de
// voorbeeldzin. Bij dubbelzijdig afdrukken met omslaan langs de lange zijde
// komt de linkerkolom van de voorkant achter de rechterkolom van de
// achterkant. Daarom staan links en rechts op de achterkant per rij
// omgewisseld (`spiegelen: true`, standaard; getest met de printer thuis).
// Elk kaartje heeft rechtsonder op beide kanten hetzelfde nummer, zodat je
// na het afdrukken meteen ziet of voor- en achterkant bij elkaar horen.
// De marges links en rechts zijn gelijk, dus kleine verschuiving van de
// printer blijft binnen het kaartje. Knippen langs de stippellijnen.

#let _kaart-b = 9.5cm
#let _kaart-h = 5.5cm

#let _kaartlabel(thema, w, nr) = {
  place(bottom + left, dy: 0.38cm, text(size: 9pt, fill: zacht)[#thema · week #w.week])
  place(bottom + right, dy: 0.38cm, text(size: 9pt, fill: zacht)[#nr])
}

#let _voorkant(thema, w, nr) = {
  let lang = w.woord.len() > 13
  align(center + horizon, {
    set par(leading: 0.45em)
    if w.at("lidwoord", default: none) != none {
      text(size: if lang { 20pt } else { 24pt }, w.lidwoord)
      [ ]
    }
    text(size: if lang { 20pt } else { 24pt }, weight: 800, w.woord)
  })
  _kaartlabel(thema, w, nr)
}

#let _achterkant(thema, w, nr) = {
  align(center + horizon, block(width: 100%, {
    set par(leading: 0.5em, justify: false)
    text(size: 16pt, w.at("kaartje", default: w.uitleg))
    v(0.2cm)
    text(size: 14pt, style: "italic", fill: luma(60), _zin(w))
  }))
  _kaartlabel(thema, w, nr)
}

#let _kaartvel(cellen) = grid(
  columns: (_kaart-b,) * 2,
  rows: (_kaart-h,) * 5,
  stroke: (paint: luma(140), thickness: 0.5pt, dash: "dashed"),
  inset: (x: 0.45cm, top: 0.3cm, bottom: 0.6cm),
  ..cellen,
)

#let woordkaartjes(woorden, thema: "", spiegelen: true) = {
  set document(title: "Woordkaartjes – " + thema)
  set text(font: letter, size: grootte, lang: "nl", weight: 400, hyphenate: false)
  set page(
    paper: "a4",
    margin: (x: (21cm - 2 * _kaart-b) / 2, y: (29.7cm - 5 * _kaart-h) / 2),
    header: none,
    footer: context {
      set text(size: 7pt, fill: zacht)
      let voor = calc.odd(here().page())
      align(center)[Woordkaartjes #thema · #if voor [voorkant: woorden] else [achterkant: betekenissen] · dubbelzijdig, omslaan langs de lange zijde, 100% · vel #calc.ceil(here().page() / 2)]
    },
    footer-descent: 0.25cm,
  )
  // (nummer, woord) zodat voor- en achterkant hetzelfde nummer krijgen
  let vellen = woorden.enumerate(start: 1).chunks(10)
  for (i, vel) in vellen.enumerate() {
    if i > 0 { pagebreak() }
    let leeg = 10 - vel.len()
    // voorkant: rij voor rij, links naar rechts
    _kaartvel(vel.map(((nr, w)) => _voorkant(thema, w, nr)) + ([],) * leeg)
    pagebreak()
    // achterkant: per rij links en rechts omgewisseld (lange zijde)
    let rijen = (vel + (none,) * leeg).chunks(2)
    if spiegelen { rijen = rijen.map(r => r.rev()) }
    _kaartvel(rijen.map(r => r.map(c => if c == none { [] } else { _achterkant(thema, c.at(1), c.at(0)) })).join())
  }
}

// ---------------------------------------------------------------------------
// Woordenschatbingo (gegenereerd uit woorden.yaml)
// ---------------------------------------------------------------------------
//
// Pagina 1: spelregels en de voorleeslijst (betekenis van de uitgever, veld
// `kaartje`, of het veld `bingo` als dat er is, in een vaste gehusselde volgorde). Daarna bingokaarten van 4 x 4,
// twee per pagina, elk met een andere keuze en volgorde van woorden.

#let _bingowoord(w) = {
  set par(leading: 0.4em, justify: false)
  set text(hyphenate: true)
  if w.at("lidwoord", default: none) != none {
    text(size: 12pt, w.lidwoord)
    linebreak()
  }
  // Optioneel veld `afbreken` in woorden.yaml, bijv. "gebruiks-aanwijzing".
  let af = w.at("afbreken", default: none)
  if af != none {
    text(weight: 800, hyphenate: false, af.split("-").join([-#linebreak()]))
  } else {
    text(weight: 800, w.woord)
  }
}

#let _bingokaart(woorden, nr) = block(width: 100%, breakable: false, above: 0pt, below: 0.6cm, {
  grid(
    columns: (auto, 1fr, auto, 5cm),
    column-gutter: 8pt,
    align: bottom,
    _kop([Bingokaart #nr], size: 16pt), [],
    [Naam:], box(width: 100%, height: 0.8cm, stroke: (bottom: 0.7pt + lijnkleur)),
  )
  v(0.2cm)
  table(
    columns: (1fr,) * 4,
    rows: (2.55cm,) * 4,
    align: center + horizon,
    inset: 5pt,
    stroke: 1.2pt + black,
    ..woorden.map(_bingowoord),
  )
})

#let bingo(woorden, thema: "", kaarten: 6, seed: 2026) = {
  let totaal = woorden.len()
  let woorden = woorden.filter(w => not _uitdrukking(w))
  assert(woorden.len() >= 16, message: "Een bingokaart heeft 16 woorden; de lijst heeft er " + str(woorden.len()) + " (zonder uitdrukkingen). Voeg woorden toe.")
  _bladkop([Woordenschatbingo], [Woordenschatbingo], [Met de #totaal woorden van het thema], naam: false)

  opdracht(none, [Zo speel je het])[
    - Iedereen krijgt een bingokaart.
    - De voorlezer leest een betekenis voor.
    - Staat het woord dat erbij hoort op jouw kaart? Zet er een kruisje op, of leg er een pepernoot op.
    - Een rij vol? Dat mag recht, van boven naar beneden of schuin. Roep: *Bingo!*
    - Lees dan de woorden van je rij hardop voor. Weet je nog wat ze betekenen?
  ]

  block(breakable: true, {
    _kop([Voorleeslijst], size: 16pt)
    v(0.1cm)
    text(size: 11pt)[Voor de voorlezer. Lees de betekenissen van boven naar beneden voor en zet een vinkje. Het woord staat erachter, om na te kijken.]
    v(0.2cm)
    set text(size: 11.5pt)
    table(
      columns: (0.8cm, 1fr, 5.2cm),
      inset: (x: 5pt, y: 5pt),
      align: (center + horizon, left + horizon, left + horizon),
      stroke: (x, y) => (bottom: 0.5pt + luma(160)),
      table.header([], strong[Betekenis], strong[Woord]),
      ..hussel(woorden, seed).map(w => (
        box(width: 0.45cm, height: 0.45cm, stroke: 0.8pt + black),
        w.at("bingo", default: w.at("kaartje", default: w.uitleg)),
        text(fill: zacht, if w.at("lidwoord", default: none) != none [#w.lidwoord #w.woord] else [#w.woord]),
      )).flatten(),
    )
  })

  for k in range(kaarten) {
    if calc.even(k) { pagebreak() }
    [#metadata([Bingokaarten]) <blad>]
    let keuze = hussel(woorden, seed + 101 * (k + 1)).slice(0, 16)
    _bingokaart(keuze, k + 1)
  }
}

// ---------------------------------------------------------------------------
// Woordzoeker (gegenereerd uit woorden.yaml)
// ---------------------------------------------------------------------------
//
// Per week twee puzzels van 12 x 12. Woorden staan alleen van links naar
// rechts of van boven naar beneden (niet schuin, niet achterstevoren).
// "ij" staat in één vakje. Woorden met een spatie of langer dan het rooster
// doen niet mee; "zich opdoffen" wordt "opdoffen". Vaste seed, dus bij
// opnieuw compileren dezelfde puzzel; de oplossing komt uit dezelfde functie.

#let _ws-letters(w) = {
  let cs = w.clusters()
  let uit = ()
  let i = 0
  while i < cs.len() {
    if cs.at(i) == "i" and i + 1 < cs.len() and cs.at(i + 1) == "j" {
      uit.push("ij")
      i += 2
    } else {
      uit.push(cs.at(i))
      i += 1
    }
  }
  uit
}

#let _ws-rnd(s) = calc.rem(s * 1103515245 + 12345, 2147483648)
#let _ws-kies(s, n) = calc.rem(calc.quo(s, 65536), n)

// Welke woorden doen mee, per week in twee groepen.
#let _ws-selectie(woorden, maat) = {
  let groepen = ()
  let weg = ()
  // Alleen de weken die in de woorden voorkomen.
  for week in woorden.map(w => w.week).dedup().sorted() {
    let lijst = ()
    for w in woorden.filter(w => w.week == week and not _uitdrukking(w)) {
      // `zoekwoord` in de yaml geeft het woord voor de puzzel, bijv. "scherp" voor "scherp (zien)".
      let woord = w.at("zoekwoord", default: if w.woord.starts-with("zich ") { w.woord.slice(5) } else { w.woord })
      if woord.contains(" ") or _ws-letters(woord).len() > maat {
        weg.push(w.woord)
      } else {
        lijst.push(woord)
      }
    }
    // Veel woorden: verdelen over twee puzzels. Weinig (≤ 6): één puzzel.
    if lijst.len() > 6 {
      let half = calc.ceil(lijst.len() / 2)
      groepen.push((week: week, woorden: lijst.slice(0, half)))
      groepen.push((week: week, woorden: lijst.slice(half)))
    } else if lijst.len() > 0 {
      groepen.push((week: week, woorden: lijst))
    }
  }
  (groepen: groepen, weg: weg)
}

#let _ws-plaats(woorden, maat, seed) = {
  let rooster = range(maat * maat).map(_ => none)
  let s = seed
  let plekken = ()
  for w in woorden.sorted(key: w => -_ws-letters(w).len()) {
    let l = _ws-letters(w)
    let gelukt = false
    let poging = 0
    while not gelukt and poging < 2000 {
      poging += 1
      s = _ws-rnd(s)
      let dir = _ws-kies(s, 2)
      s = _ws-rnd(s)
      let r = _ws-kies(s, if dir == 0 { maat } else { maat - l.len() + 1 })
      s = _ws-rnd(s)
      let c = _ws-kies(s, if dir == 0 { maat - l.len() + 1 } else { maat })
      let idx = range(l.len()).map(k => if dir == 0 { r * maat + c + k } else { (r + k) * maat + c })
      let ok = true
      let overlap = 0
      for (k, i) in idx.enumerate() {
        let cur = rooster.at(i)
        if cur != none {
          if cur != l.at(k) { ok = false } else { overlap += 1 }
        }
      }
      if ok and overlap < 2 {
        for (k, i) in idx.enumerate() { rooster.at(i) = l.at(k) }
        plekken.push((woord: w, cellen: idx))
        gelukt = true
      }
    }
    if not gelukt { panic("woordzoeker: kan '" + w + "' niet plaatsen; kies een andere seed") }
  }
  let vul = "aaabdeeeeefghiklmnnnoooprrssttuvwz".clusters()
  for i in range(rooster.len()) {
    if rooster.at(i) == none {
      s = _ws-rnd(s)
      rooster.at(i) = vul.at(_ws-kies(s, vul.len()))
    }
  }
  (rooster: rooster, plekken: plekken)
}

#let _ws-rooster(p, maat, cel, grootte, oplossing: false) = {
  let gevonden = p.plekken.map(x => x.cellen).flatten()
  table(
    columns: (cel,) * maat,
    rows: (cel,) * maat,
    align: center + horizon,
    inset: 0pt,
    stroke: 0.5pt + luma(170),
    fill: (x, y) => if oplossing and (y * maat + x) in gevonden { luma(215) },
    ..p.rooster.enumerate().map(((i, ch)) => {
      if oplossing {
        if i in gevonden { text(size: grootte, weight: 800, ch) } else { text(size: grootte, fill: luma(150), ch) }
      } else {
        text(size: grootte, ch)
      }
    }),
  )
}

#let woordzoekers(woorden, maat: 12, seed: 4242) = {
  let sel = _ws-selectie(woorden, maat)
  for (n, g) in sel.groepen.enumerate() {
    let p = _ws-plaats(g.woorden, maat, seed + 7919 * (n + 1))
    werkblad(n + 1, [Woorden van week #g.week], soort: "Woordzoeker")
    block(breakable: false, {
      block(below: 0.35cm)[Zoek de woorden. Ze staan van links naar rechts #sym.arrow.r of van boven naar beneden #sym.arrow.b. Zet een rondje om het woord. Streep het woord in de lijst door.]
      align(center, _ws-rooster(p, maat, 1.15cm, 18pt))
      v(0.3cm)
      woordbalk(..g.woorden)
    })
  }
}

// Oplossingen voor antwoorden.typ: kleine roosters met de woorden grijs.
#let woordzoeker-oplossingen(woorden, maat: 12, seed: 4242) = {
  let sel = _ws-selectie(woorden, maat)
  let blokken = sel.groepen.enumerate().map(((n, g)) => {
    let p = _ws-plaats(g.woorden, maat, seed + 7919 * (n + 1))
    block(breakable: false, {
      strong[Woordzoeker #(n + 1) (week #g.week)]
      v(0.1cm)
      _ws-rooster(p, maat, 0.6cm, 9pt, oplossing: true)
    })
  })
  grid(columns: (1fr, 1fr), column-gutter: 0.6cm, row-gutter: 0.6cm, ..blokken)
  if sel.weg.len() > 0 {
    v(0.2cm)
    [Niet in de woordzoeker (te lang of met een spatie): #sel.weg.join(", ").]
  }
}
