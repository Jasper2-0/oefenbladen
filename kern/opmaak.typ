// Kern van alle oefenbladen (Typst 0.15): pagina-opmaak, koppen,
// opdrachtblokken, schrijflijnen, kiezen/koppelen, lezen en ouderbladen.
// Vakfuncties staan in vakken/<vak>/<vak>.typ; die importeren dit bestand.
//
// Compileren vanuit de projectmap:
//   typst compile --root . --font-path fonts prive/groep-4/taal/kleding/werkbladen.typ prive/uit/groep-4/taal/blok-2-kleding/werkbladen.pdf

// ---------------------------------------------------------------------------
// Basis
// ---------------------------------------------------------------------------

#let letter = "Avenir"        // tekst (Book 400, vet = Heavy 800)
#let kopletter = "Nexa"       // titels en koppen (alleen Heavy 900)
#let grootte = 14pt           // tekst voor het kind
#let regel = 1.2cm            // hoogte van een schrijflijn
#let lijnkleur = luma(110)
#let vlak = luma(238)         // licht kader voor voorbeelden
#let zacht = luma(90)         // grijze bijtekst

#let _thema = state("thema", "")
#let _groep = state("groep", none)

// Voorspelbaar husselen: zelfde seed = zelfde volgorde bij opnieuw
// compileren (bingokaarten, leesbladen).
#let hussel(lijst, seed) = {
  let a = lijst
  let s = seed
  for i in range(a.len() - 1, 0, step: -1) {
    s = calc.rem(s * 1103515245 + 12345, 2147483648)
    let j = calc.rem(s, i + 1)
    let t = a.at(i)
    a.at(i) = a.at(j)
    a.at(j) = t
  }
  a
}

#let _kop(body, size: 16pt) = text(font: kopletter, weight: 900, size: size, body)

// Instellingen voor een heel document. `ouder: true` geeft kleinere tekst
// voor bladen die de ouder leest (antwoorden). `label` staat voor de
// themanaam in de kop en de voettekst, bijvoorbeeld "Rekenen" + "blok 3".
// `groep` (bijv. 3 of 4) staat in de kop, in een vakje rechtsboven en in de
// voettekst, zodat geprinte bladen van verschillende groepen uit elkaar te
// houden zijn.
#let oefenbladen(thema: "", soort: "", ouder: false, label: "Thema", groep: none, body) = {
  set document(title: soort + " – " + thema)
  set text(font: letter, size: if ouder { 11.5pt } else { grootte }, lang: "nl", weight: 400)
  set par(leading: 0.75em, spacing: 1em)
  show strong: set text(weight: 800)
  set list(marker: [•], indent: 0.3em, body-indent: 0.6em, spacing: 0.7em)
  set table.cell(breakable: false)
  show heading: set text(font: kopletter, weight: 900)
  show heading.where(level: 1): set text(size: 20pt)
  show heading.where(level: 1): set block(above: 1.2em, below: 0.8em)
  show heading.where(level: 2): set text(size: 14pt)
  show heading.where(level: 2): set block(above: 1.4em, below: 0.7em)

  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2cm, bottom: 2.4cm),
    footer: context {
      let p = here().page()
      let bladen = query(<blad>).filter(m => m.location().page() <= p)
      let blad = if bladen.len() > 0 { bladen.last().value } else { soort }
      set text(size: 10pt, fill: zacht, weight: 400)
      line(length: 100%, stroke: 0.5pt + luma(180))
      v(-4pt)
      grid(
        columns: (1fr, auto, 1fr),
        align(left)[#if groep != none [Groep #groep · ]#label #thema],
        align(center, blad),
        align(right)[pagina #counter(page).display()],
      )
    },
  )
  _thema.update(label + " " + thema)
  _groep.update(groep)
  body
}

// Kop bovenaan een blad. `naam: false` laat Naam en Datum weg.
#let _bladkop(boven, titel, ondertitel, naam: true) = {
  pagebreak(weak: true)
  [#metadata(boven) <blad>]
  block(width: 100%, below: 0.9cm, {
    context {
      let g = _groep.get()
      let links = {
        text(size: 10pt, fill: zacht, tracking: 0.08em, upper(if g != none [Groep #g · ] + _thema.get()))
        v(-2pt)
        _kop(titel, size: 26pt)
        if ondertitel != none {
          v(-6pt)
          text(size: 16pt, ondertitel)
        }
      }
      if g == none { links } else {
        grid(columns: (1fr, auto), column-gutter: 12pt, align: (left + top, right + top),
          links,
          box(width: 1.7cm, inset: (y: 5pt), radius: 6pt, stroke: 1.5pt + black, align(center, {
            text(size: 9pt, tracking: 0.08em, upper[groep])
            v(-8pt)
            _kop(str(g), size: 26pt)
          })),
        )
      }
    }
    if naam {
      v(4pt)
      grid(
        columns: (auto, 3fr, auto, 2fr),
        column-gutter: (8pt, 20pt, 8pt),
        align: bottom,
        [Naam:], box(width: 100%, height: 0.9cm, stroke: (bottom: 0.7pt + lijnkleur)),
        [Datum:], box(width: 100%, height: 0.9cm, stroke: (bottom: 0.7pt + lijnkleur)),
      )
    }
    v(2pt)
    line(length: 100%, stroke: 1.5pt)
  })
}

// Begin van een werkblad, altijd op een nieuwe pagina.
#let werkblad(nummer, titel, soort: "Werkblad") = _bladkop([#soort #nummer], [#soort #nummer], titel)

// Een korte tekst onder de kop, bijvoorbeeld de inleiding van werkblad 5.
#let inleiding(body) = block(width: 100%, below: 0.6cm, body)

// ---------------------------------------------------------------------------
// Opdrachten
// ---------------------------------------------------------------------------

#let _bolletje(n) = box(
  width: 1.45em, height: 1.45em, radius: 50%, fill: black,
  align(center + horizon, text(font: kopletter, weight: 900, fill: white, size: 13pt, str(n))),
)

// Een afgebakende opdracht die nooit over een paginagrens loopt.
// `nummer` is een getal (bolletje) of none (alleen titel).
#let opdracht(nummer, titel, instructie: none, body) = block(
  width: 100%, breakable: false, above: 0.95cm, below: 0.95cm,
  {
    grid(
      columns: if nummer == none { (1fr,) } else { (auto, 1fr) },
      column-gutter: 10pt,
      align: horizon,
      ..if nummer != none { (_bolletje(nummer),) },
      _kop(titel),
    )
    if instructie != none {
      v(4pt)
      block(below: 0.45cm, instructie)
    }
    body
  },
)

// Voorbeeld in een licht kader. Vraagt de opdracht om iets te omcirkelen,
// in te vullen of te ordenen, dan laat het voorbeeld dat ingevuld zien met
// dezelfde vorm: zie de `voorbeeld:`-parameter van de functies hieronder,
// en `tekst:` van invul en vakje, `goed:` van kies en meerkeuze.
#let voorbeeld(body) = block(
  width: 100%, fill: vlak, radius: 6pt, inset: (x: 12pt, y: 10pt),
  above: 0.3cm, below: 0.45cm,
  [#strong[Voorbeeld:] #h(4pt) #body],
)
// Dezelfde functie onder een andere naam, voor functies met een parameter
// `voorbeeld`.
#let voorbeeld_ = voorbeeld

// Een tip of korte uitleg, zonder kader.
#let tip(body) = block(above: 0.2cm, below: 0.4cm, text(style: "normal", [#strong[Tip:] #body]))

// ---------------------------------------------------------------------------
// Schrijven
// ---------------------------------------------------------------------------

// Hele schrijflijnen over de breedte van de tekst.
#let schrijflijnen(aantal: 1) = block(width: 100%, above: 0pt, below: 0.3cm,
  stack(..range(aantal).map(_ => block(
    width: 100%, height: regel, stroke: (bottom: 0.7pt + lijnkleur),
  ))),
)

// Een ingevuld antwoord in een voorbeeld: vet en zwart.
#let _ingevuld(body) = text(weight: 800, body)

// Invullijn in een zin met een vaste breedte. `tekst`: al ingevuld (voor
// een voorbeeld).
#let invul(breedte: 4.5cm, tekst: none) = box(
  width: breedte, height: 1em, baseline: 0.3em,
  stroke: (bottom: 0.7pt + lijnkleur),
  if tekst != none { place(center + bottom, dy: -0.12em, _ingevuld(tekst)) },
)

// Invullijn die de rest van de regel vult. `tekst`: al ingevuld.
#let lijn(tekst: none) = box(width: 1fr, height: 1em, baseline: 0.3em, stroke: (bottom: 0.7pt + lijnkleur),
  if tekst != none { place(left + bottom, dx: 0.4em, dy: -0.12em, _ingevuld(tekst)) })

// Klein vakje voor een letter, cijfer of leesteken. `tekst`: al ingevuld
// (voor een voorbeeld; het vakje is dan wit).
#let vakje(breedte: 1.1cm, tekst: none) = box(
  width: breedte, height: 1.1cm, baseline: 0.35cm, radius: 3pt,
  stroke: 0.9pt + black,
  fill: if tekst != none { white },
  if tekst != none { align(center + horizon, text(size: 16pt, _ingevuld(tekst))) },
)

// Genummerde zinnen met ruimte om te schrijven. Elke zin is een los argument.
// Het nummer staat op dezelfde basislijn als de eerste regel van de zin.
#let zinnen(start: 1, nummers: true, ruimte: 0.75cm, ..items) = {
  if nummers {
    enum(start: start, numbering: "1.", spacing: ruimte, indent: 0pt, body-indent: 0.7em,
      ..items.pos())
  } else {
    stack(spacing: ruimte, ..items.pos().map(z => block(z)))
  }
}

// Een zin overschrijven: de zin, met een schrijflijn eronder.
#let overschrijven(..items) = enum(
  numbering: "1.", spacing: 0.3cm, indent: 0pt, body-indent: 0.7em,
  ..items.pos().map(z => { z; v(-0.45cm); schrijflijnen(aantal: 1) }),
)

// Tekenvak op het blad zelf (in plaats van "op de achterkant").
#let tekenvak(hoogte: 8cm, opschrift: none) = block(
  width: 100%, height: hoogte, radius: 8pt, inset: 10pt,
  stroke: (paint: luma(90), thickness: 1pt, dash: "dashed"),
  above: 0.3cm, below: 0.4cm,
  if opschrift != none { text(size: 11pt, fill: zacht, opschrift) },
)

// ---------------------------------------------------------------------------
// Kiezen, koppelen, ordenen
// ---------------------------------------------------------------------------

// Keuzes in een zin: vet, met ruimte eromheen om te omcirkelen.
// `goed`: het woord met een rondje erom (voor een voorbeeld).
#let kies(scheiding: "/", goed: none, ..opties) = {
  let delen = opties.pos().map(o => if goed != none and o == goed {
    box(inset: (x: 8pt), outset: (y: 6pt), radius: 50%, stroke: 1.4pt + black, strong(o))
  } else { box(inset: (x: 8pt), outset: (y: 6pt), strong(o)) })
  if scheiding == none {
    delen.join(h(0.6em))
  } else {
    // De keuzes blijven samen op één regel.
    box(delen.join(text(fill: zacht, scheiding)))
  }
}

// Woordbalk: de keuzewoorden als rij losse kaders.
#let woordbalk(..woorden) = block(width: 100%, above: 0.2cm, below: 0.55cm,
  align(center, {
    set par(leading: 1.1em)
    woorden.pos().map(w => box(
      stroke: 1pt + black, radius: 5pt, inset: (x: 8pt, y: 7pt),
      strong(w),
    )).join(h(6pt))
  }),
)

// Koppeltabel: woord, een leeg vakje, betekenis.
// rijen: (woord, betekenis), ...  `voorbeeld` vult de eerste letter al in.
#let koppeltabel(start: 1, voorbeeld: none, ..rijen) = {
  let letters = ("a", "b", "c", "d", "e", "f", "g", "h")
  table(
    columns: (1fr, 1.9cm, 1.35fr),
    align: (left + horizon, center + horizon, left + horizon),
    inset: (x: 8pt, y: 5pt),
    stroke: (x, y) => (bottom: 0.6pt + luma(150)),
    table.header(
      text(size: 11pt, fill: zacht)[Woord],
      text(size: 11pt, fill: zacht)[Letter],
      text(size: 11pt, fill: zacht)[Betekenis],
    ),
    ..rijen.pos().enumerate().map(((i, r)) => (
      [#(start + i). #r.at(0)],
      if i == 0 and voorbeeld != none {
        box(width: 1cm, height: 1cm, radius: 3pt, stroke: 0.9pt + black,
          align(center + horizon, text(fill: zacht, strong(voorbeeld))))
      } else {
        box(width: 1cm, height: 1cm, radius: 3pt, stroke: 0.9pt + black)
      },
      [#strong(letters.at(i)). #r.at(1)],
    )).flatten(),
  )
}

// Welk woord hoort er niet bij? Elke rij is een lijst woorden.
#let nietbij(..rijen) = zinnen(
  ..rijen.pos().map(r => r.join(h(0.5em) + [–] + h(0.5em))),
)

// Doorgestreept woord (voor het voorbeeld).
#let doorgestreept(body) = strike(stroke: 1.6pt, body)

// Onderstreept woord (voor het voorbeeld).
#let onderstreept(body) = underline(stroke: 1.6pt, offset: 3pt, body)

// Goed of fout: zin met de keuze goed / fout. `voorbeeld`: (zin, "goed" of
// "fout"), een grijze rij bovenaan met het antwoord omcirkeld.
#let goedfout(voorbeeld: none, ..zinnen) = table(
  columns: (1.6em, 1fr, auto),
  align: (left + horizon, left + horizon, center + horizon),
  inset: (x: 6pt, y: 8pt),
  stroke: (x, y) => (bottom: 0.6pt + luma(150)),
  ..if voorbeeld != none {
    let (z, a) = voorbeeld
    ([], z, kies("goed", "fout", goed: a)).map(c => table.cell(fill: vlak, c))
  },
  ..zinnen.pos().enumerate().map(((i, z)) => (
    [#(i + 1).], z, kies("goed", "fout"),
  )).flatten(),
)

// Volgorde: een vakje voor het cijfer, dan de zin. `voorbeeld`: een lijst
// van (nummer, zin), in een voorbeeldkader met de nummers ingevuld.
#let volgorde(voorbeeld: none, ..items) = {
  let rooster(rijen) = grid(
    columns: (1.5cm, 1fr),
    row-gutter: 0.35cm,
    align: horizon,
    ..rijen.flatten(),
  )
  if voorbeeld != none {
    voorbeeld_(rooster(voorbeeld.map(((n, z)) => (vakje(tekst: str(n)), z))))
  }
  rooster(items.pos().map(z => (vakje(), z)))
}

// Het omgekeerde: woord ↔ invullijn. `voorbeeld`: (woord, tegendeel).
#let tegendeel(voorbeeld: none, ..woorden) = {
  let rij(w, t) = [#w #h(0.4em) ↔ #h(0.4em) #invul(breedte: 5cm, tekst: t)]
  if voorbeeld != none { voorbeeld_(rij(..voorbeeld)) }
  zinnen(..woorden.pos().map(w => rij(w, none)))
}

// Twee woorden worden één woord. Een paar ("stappen", "plan") wordt een
// som met een invullijn; een `zelf` maakt een rij met drie lege lijnen.
#let zelf(tekst) = [#tekst #invul(breedte: 2.6cm) + #invul(breedte: 2.6cm) = #invul(breedte: 3.6cm)]
// `voorbeeld`: (woord, woord, samen).
#let samenstelling(voorbeeld: none, ..paren) = {
  let som(a, b, samen) = [#a + #b = #invul(breedte: 5.5cm, tekst: samen)]
  if voorbeeld != none { voorbeeld_(som(..voorbeeld)) }
  zinnen(..paren.pos().map(p => if type(p) == array { som(p.at(0), p.at(1), none) } else { p }))
}

// Punt of vraagteken: zin met een vakje erachter. `voorbeeld`: (zin, teken).
#let leesteken(voorbeeld: none, ..zinnen-lijst) = {
  if voorbeeld != none { voorbeeld_[#voorbeeld.at(0) #h(0.3em) #vakje(tekst: voorbeeld.at(1))] }
  zinnen(
    ruimte: 0.45cm,
    ..zinnen-lijst.pos().map(z => [#z #h(0.3em) #vakje()]),
  )
}

// ---------------------------------------------------------------------------
// Lezen
// ---------------------------------------------------------------------------

// Leesverhaal: grotere letter en regelafstand, korte regels.
// De woorden van de week staan vet in de tekst (*woord*).
#let verhaal(titel, body) = block(width: 100%, above: 0.6cm, below: 0.6cm, {
  _kop(titel, size: 20pt)
  v(0.2cm)
  block(width: 15cm, {
    set text(size: 14.5pt)
    set par(leading: 0.95em, spacing: 1.15em)
    set list(spacing: 0.9em)
    body
  })
})

// Het volgende deel begint op een nieuwe pagina (bijvoorbeeld de vragen na
// het leesverhaal).
#let nieuwepagina() = pagebreak(weak: true)

// Meerkeuzevraag: vraag met keuzes a, b, c om te omcirkelen. `goed`: de
// letter met een rondje erom, en `nummer: none` (voor een voorbeeld).
#let meerkeuze(nummer, vraag, goed: none, ..opties) = block(
  width: 100%, breakable: false, above: 0.5cm, below: 0.5cm,
  {
    if nummer == none { strong(vraag) } else { strong[#nummer. #vraag] }
    v(2pt)
    let lijst = opties.pos()
    let letters = ("a", "b", "c", "d")
    grid(
      columns: (1fr,) * lijst.len(), column-gutter: 10pt,
      ..lijst.enumerate().map(((i, o)) => grid(
        columns: (1.4em, 1fr),
        if letters.at(i) == goed {
          box(outset: (x: 5pt, y: 4pt), radius: 50%, stroke: 1.4pt + black, strong(letters.at(i)))
        } else { box(outset: (y: 4pt), strong(letters.at(i))) }, o,
      )),
    )
  },
)

// Open vraag met schrijflijnen.
#let openvraag(nummer, vraag, lijnen: 1, body: none) = block(
  width: 100%, breakable: false, above: 0.5cm, below: 0.5cm,
  {
    strong[#nummer. #vraag]
    if body != none { v(2pt); body }
    schrijflijnen(aantal: lijnen)
  },
)

// Vraag met een eigen invulvorm (bijvoorbeeld volgorde).
#let vraag(nummer, tekst, body) = block(
  width: 100%, breakable: false, above: 0.5cm, below: 0.5cm,
  {
    strong[#nummer. #tekst]
    v(4pt)
    body
  },
)

// ---------------------------------------------------------------------------
// Antwoorden en uitleg voor de ouder
// ---------------------------------------------------------------------------

#let ouderblad(titel) = _bladkop([#titel], [#titel], none, naam: false)

// Eenvoudige tabel voor de ouder. kop: (..), rijen: (..), (..)
#let tabel(kop: (), ..rijen) = table(
  columns: kop.len(),
  inset: (x: 6pt, y: 6pt),
  align: left + top,
  stroke: (x, y) => (bottom: 0.5pt + luma(150)),
  table.header(..kop.map(k => strong(k))),
  ..rijen.pos().flatten(),
)

