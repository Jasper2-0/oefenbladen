// Rekenen (De wereld in getallen 5, groep 3 t/m 8): getallenlijn,
// rekenrek, geld en sommen. Bevat ook alles uit kern/opmaak.typ, dus een
// rekenbestand importeert alleen dit bestand.
//
// Antwoorden: elke functie rekent het antwoord zelf uit. Compileer je met
// `--input oplossing=ja`, dan staan de antwoorden ingevuld (grijs, vet). Zo
// is het antwoordenblad altijd precies hetzelfde blad als dat van het kind.

#import "/kern/opmaak.typ": *

#let oplossing = sys.inputs.at("oplossing", default: "nee") == "ja"
#let antwoordkleur = luma(95)

// In een voorbeeld (`rekenvoorbeeld`) staan de antwoorden er altijd, in
// zwart; zo ziet het voorbeeld er precies uit als de opdracht, maar dan
// ingevuld.
#let _vb = state("rekenvoorbeeld", false)

// Een ingevuld antwoord (alleen zichtbaar met oplossing=ja of in een
// voorbeeld).
#let _antw(body) = context {
  if _vb.get() { text(weight: 800, body) }
  else if oplossing { text(fill: antwoordkleur, weight: 800, body) }
}

#let _teken(op) = if op == "+" { "+" } else { "−" }
#let _reken(a, op, b) = if op == "+" { a + b } else { a - b }

// Vak in de tekstregel. De inhoud staat met `place`, zodat een vol en een
// leeg vak op dezelfde hoogte staan.
// In een voorbeeld is een leeg vak wit, zodat het op het grijze kader opvalt.
#let _regelvak(breedte, inhoud, fill: auto, stroke: 0.9pt + black) = context box(
  width: breedte, height: 1.05cm, baseline: 0.33cm, radius: 3pt,
  fill: if fill == auto { if _vb.get() { white } else { none } } else { fill },
  stroke: stroke,
  place(center + horizon, inhoud),
)

// Invulvak voor een getal.
#let vak(waarde, breedte: 1.5cm) = _regelvak(breedte, _antw(str(waarde)))

// Invullijn met een antwoord (voor een som of een woord).
#let antwoordlijn(waarde, breedte: 4cm) = box(
  width: breedte, height: 1em, baseline: 0.3em, stroke: (bottom: 0.7pt + lijnkleur),
  place(center + bottom, dy: -0.1em, _antw(waarde)),
)

// Voorbeeld bij een opdracht met iets om te tekenen of in te vullen: zet
// dezelfde functie erin, met andere getallen dan in de opdracht. Het
// voorbeeld toont dan hetzelfde plaatje, al ingevuld. Bij functies met
// nummers (welkgetal, zetpijl, kloptbedrag): `nummers: false`.
#let rekenvoorbeeld(body) = voorbeeld[#_vb.update(true)#body#_vb.update(false)]

// ---------------------------------------------------------------------------
// Getallenlijn
// ---------------------------------------------------------------------------
//
// soort: "streepjes" (streepje bij elk getal, lang bij de tientallen),
// "bijnaleeg" (alleen streepjes bij `labels`) of "leeg" (alleen een lijn).
// pijlen: getallen met een pijl; een vak boven de pijl (antwoord in de
//   oplossing), of het getal zelf als het in `toon` staat.
// bogen: (van, naar) sprongen met het verschil erboven.
//   `opl-bogen` worden alleen in de oplossing getekend.
// vrij: (getal, tekst) losse tekst onder de lijn, bijvoorbeeld het startgetal
//   op een lege getallenlijn.

#let _boog(x1, x2, y, label) = {
  let h = calc.min(1.1cm, 0.35cm + calc.abs(x2 - x1) * 0.35)
  let xm = (x1 + x2) / 2
  let pijl = if x2 > x1 { -1 } else { 1 }
  place(top + left, curve(stroke: 1.1pt,
    curve.move((x1, y)), curve.cubic((x1, y - h), (x2, y - h), (x2, y))))
  place(top + left, polygon(fill: black,
    (x2, y), (x2 + pijl * 0.2cm, y - 0.22cm), (x2 - pijl * 0.06cm, y - 0.3cm)))
  place(top + left, dx: xm - 1cm, dy: y - h - 0.55cm,
    box(width: 2cm, align(center, text(size: 12pt, weight: 800, label))))
}

#let getallenlijn(
  van: 0, tot: 100, breedte: 15.5cm, soort: "streepjes", labels: auto,
  pijlen: (), toon: (), bogen: (), opl-bogen: (), opl-pijlen: (), vrij: (),
  boven: 1.75cm,
) = {
  let x(v) = (v - van) / (tot - van) * breedte
  let lijn-y = boven
  let labels = if labels == auto {
    if soort == "streepjes" { range(van, tot + 1).filter(v => calc.rem(v, 10) == 0) } else { (van, tot) }
  } else { labels }
  // De lijn staat op de basislijn van de tekst, dus een nummer ervoor
  // staat netjes naast de lijn.
  context box(width: breedte, height: lijn-y + 0.85cm, baseline: 0.85cm, {
    // In een voorbeeld staan de antwoorden er in zwart.
    let vb = _vb.get()
    let toon-opl = oplossing or vb
    let ak = if vb { black } else { antwoordkleur }
    place(top + left, line(start: (0pt, lijn-y), end: (breedte, lijn-y), stroke: 1.2pt))
    if soort == "streepjes" {
      for v in range(van, tot + 1) {
        let h = if calc.rem(v, 10) == 0 { 0.45cm } else if calc.rem(v, 5) == 0 { 0.3cm } else { 0.18cm }
        place(top + left, line(start: (x(v), lijn-y - h / 2), end: (x(v), lijn-y + h / 2), stroke: 0.7pt))
      }
    } else if soort == "bijnaleeg" {
      for v in labels {
        place(top + left, line(start: (x(v), lijn-y - 0.22cm), end: (x(v), lijn-y + 0.22cm), stroke: 1pt))
      }
    }
    if soort != "leeg" {
      for v in labels {
        place(top + left, dx: x(v) - 1cm, dy: lijn-y + 0.3cm,
          box(width: 2cm, align(center, text(size: 11pt, str(v)))))
      }
    }
    for (v, t) in vrij {
      place(top + left, line(start: (x(v), lijn-y - 0.22cm), end: (x(v), lijn-y + 0.22cm), stroke: 1pt))
      place(top + left, dx: x(v) - 1cm, dy: lijn-y + 0.3cm,
        box(width: 2cm, align(center, text(size: 13pt, weight: 800, t))))
    }
    let alle-pijlen = pijlen + if toon-opl { opl-pijlen } else { () }
    for v in alle-pijlen {
      let opl = v in opl-pijlen
      place(top + left, line(start: (x(v), 0.95cm), end: (x(v), lijn-y - 0.12cm), stroke: 1.1pt + if opl { ak } else { black }))
      place(top + left, polygon(fill: if opl { ak } else { black },
        (x(v), lijn-y - 0.05cm), (x(v) - 0.12cm, lijn-y - 0.32cm), (x(v) + 0.12cm, lijn-y - 0.32cm)))
      if not opl {
        place(top + left, dx: x(v) - 0.7cm, dy: 0cm,
          if v in toon {
            box(width: 1.4cm, height: 0.9cm, align(center + horizon, text(size: 15pt, weight: 800, str(v))))
          } else {
            box(width: 1.4cm, height: 0.9cm, radius: 3pt, stroke: 0.9pt,
              align(center + horizon, _antw(str(v))))
          })
      }
    }
    for (a, b) in bogen { _boog(x(a), x(b), lijn-y, if b > a [+#(b - a)] else [−#(a - b)]) }
    if toon-opl {
      for (a, b) in opl-bogen {
        set text(fill: ak)
        _boog(x(a), x(b), lijn-y, if b > a [+#(b - a)] else [−#(a - b)])
        // Op een lege lijn schrijft het kind de getallen eronder.
        if soort == "leeg" {
          place(top + left, dx: x(b) - 1cm, dy: lijn-y + 0.3cm,
            box(width: 2cm, align(center, _antw(str(b)))))
        }
      }
    }
  })
}

// Sprongen op de streepjesgetallenlijn: start, aantal sprongen, stap
// (negatief = terug). Het kind tekent de sprongen en schrijft waar het
// uitkomt.
#let sprongen(start, aantal, stap: 10) = {
  let eind = start + aantal * stap
  let tussen = range(aantal).map(i => (start + i * stap, start + (i + 1) * stap))
  block(breakable: false, above: 0.3cm, below: 0.5cm, {
    grid(columns: (1fr, auto), align: horizon,
      [Begin bij *#start*. Maak *#aantal* sprongen van #calc.abs(stap) #if stap > 0 [verder] else [terug].],
      [Ik kom uit op: #vak(eind)])
    v(-0.2cm)
    getallenlijn(pijlen: (start,), toon: (start,), opl-bogen: tussen, boven: 1.9cm)
  })
}

// Een rijtje tellen: de eerste `gegeven` getallen staan er, de rest vult
// het kind in.
#let rijtje(start, stap: 10, aantal: 6, gegeven: 2) = {
  let getallen = range(aantal).map(i => start + i * stap)
  box(getallen.enumerate().map(((i, g)) => if i < gegeven {
    _regelvak(1.5cm, strong(str(g)), fill: vlak, stroke: none)
  } else { vak(g) }).join(h(0.35cm)))
}

// Een ingevulde voorbeeldrij bovenaan een tabel: grijs, met de antwoorden
// erin. `cellen` is een functie die de cellen van een rij maakt.
#let _voorbeeldrij(cellen) = cellen().map(c =>
  table.cell(fill: vlak, [#_vb.update(true)#c#_vb.update(false)]))

// Tabel: 10 minder, het getal, 10 meer. `voorbeeld`: een getal voor een
// ingevulde voorbeeldrij bovenaan.
#let meerminder(voorbeeld: none, ..getallen) = {
  let rij(g) = (vak(g - 10), text(size: 16pt, weight: 800, str(g)), vak(g + 10))
  table(
    columns: (3.4cm, 3cm, 3.4cm),
    align: center + horizon,
    inset: (x: 6pt, y: 7pt),
    stroke: 0.6pt + luma(150),
    table.header(strong[10 minder], strong[getal], strong[10 meer]),
    ..if voorbeeld != none { _voorbeeldrij(() => rij(voorbeeld)) },
    ..getallen.pos().map(rij).flatten(),
  )
}

// Welk getal hoort bij de pijl? Een bijna lege getallenlijn per getal.
#let welkgetal(van: 0, tot: 100, midden: true, start: 1, nummers: true, ..getallen) = {
  let labels = if midden { (van, calc.quo(van + tot, 2), tot) } else { (van, tot) }
  zinnen(start: start, nummers: nummers, ..getallen.pos().map(g =>
    getallenlijn(van: van, tot: tot, soort: "bijnaleeg", labels: labels, pijlen: (g,), breedte: 14.5cm)))
}

// Zet een pijl bij het getal. Het kind tekent de pijl zelf.
#let zetpijl(van: 0, tot: 100, midden: true, nummers: true, ..getallen) = {
  let labels = if midden { (van, calc.quo(van + tot, 2), tot) } else { (van, tot) }
  zinnen(nummers: nummers, ..getallen.pos().map(g => block(breakable: false, {
    [Zet een pijl bij *#g*.]
    v(-0.5cm)
    getallenlijn(van: van, tot: tot, soort: "bijnaleeg", labels: labels, opl-pijlen: (g,), breedte: 14.5cm)
  })))
}

// Een sprong van 10 op de lege getallenlijn: startgetal staat eronder, het
// kind tekent de sprong en schrijft het antwoord.
#let tiensprong(a, op) = {
  let b = _reken(a, op, 10)
  let (van, tot) = if op == "+" { (a - 3, a + 13) } else { (a - 13, a + 3) }
  block(breakable: false, above: 0.5cm, below: 0.5cm, grid(
    columns: (4.2cm, 1fr), align: bottom,
    [#a #_teken(op) 10 = #vak(b)],
    getallenlijn(van: van, tot: tot, soort: "leeg", vrij: ((a, str(a)),), opl-bogen: ((a, b),), breedte: 10.5cm, boven: 1.3cm),
  ))
}

// ---------------------------------------------------------------------------
// Sommen
// ---------------------------------------------------------------------------

// Losse sommen in kolommen. Elke som is (a, "+" of "-", b).
#let sommen(kolommen: 2, ..lijst) = grid(
  columns: (1fr,) * kolommen,
  row-gutter: 0.55cm,
  column-gutter: 0.6cm,
  ..lijst.pos().map(((a, op, b)) => [#a #_teken(op) #b = #vak(_reken(a, op, b))]),
)

// Verhaalsom: verhaal, een lijn voor de som en een vak voor het antwoord.
#let verhaalsom(tekst, a, op, b, eenheid: none) = block(breakable: false, {
  let r = _reken(a, op, b)
  tekst
  v(0.15cm)
  grid(
    columns: (auto, auto, auto, auto),
    column-gutter: 8pt,
    align: horizon,
    [Som:], antwoordlijn([#a #_teken(op) #b = #r], breedte: 5.5cm),
    h(0.8cm) + [Antwoord:], [#vak(r) #eenheid],
  )
})

// Rekenrek: twee rijen van 10 kralen. `boven` en `onder` kralen zijn naar
// links geschoven (donker), de rest zit rechts (licht).
#let rekenrek(boven, onder) = {
  let d = 0.44cm
  let rij(n) = {
    let kraal(vol) = circle(radius: d / 2, fill: if vol { luma(70) } else { white }, stroke: 0.9pt)
    let links = range(n).map(_ => kraal(true))
    let rechts = range(10 - n).map(_ => kraal(false))
    box(width: 7.2cm, {
      place(left + horizon, line(length: 7.2cm, stroke: 0.6pt + luma(130)))
      place(left + horizon, dx: 0.15cm, stack(dir: ltr, spacing: 0.04cm, ..links))
      place(right + horizon, dx: -0.15cm, stack(dir: ltr, spacing: 0.04cm, ..rechts))
      box(height: d)
    })
  }
  box(inset: (x: 0.1cm, y: 0.15cm), stroke: (left: 2pt, right: 2pt),
    stack(spacing: 0.22cm, rij(boven), rij(onder)))
}

// Rekenen via de 10, in twee stappen. Met `rek: true` staat het rekenrek
// erbij met het eerste getal.
#let _viade10-stappen(a, op, b) = {
  let stap1 = if op == "+" { 10 - a } else { a - 10 }
  (stap1, b - stap1, _reken(a, op, b))
}

// De som en de twee stappen; `vakje(waarde, breedte)` tekent een vak.
#let _viade10-sommen(a, op, b, vakje) = {
  let (stap1, stap2, r) = _viade10-stappen(a, op, b)
  text(size: 16pt)[*#a #_teken(op) #b =* #vakje(r, 1.5cm)]
  v(0.15cm)
  text(fill: zacht)[#a #_teken(op) #vakje(stap1, 1.2cm) = 10 #h(0.6cm)
    10 #_teken(op) #vakje(stap2, 1.2cm) = #vakje(r, 1.2cm)]
}

#let viade10(a, op, b, rek: false) = {
  block(breakable: false, above: 0.4cm, below: 0.6cm, grid(
    columns: if rek { (auto, 1fr) } else { (1fr,) },
    column-gutter: 0.8cm,
    align: horizon,
    ..if rek { (rekenrek(calc.min(a, 10), calc.max(a - 10, 0)),) },
    _viade10-sommen(a, op, b, (w, br) => vak(w, breedte: br)),
  ))
}

// Voorbeeld bij viade10: dezelfde vakjes, al ingevuld, met de twee
// sprongen op de getallenlijn (eerst naar de 10, dan de rest). Elke som is
// een array (a, op, b), bijvoorbeeld een plus- en een minsom.
#let viade10-voorbeeld(..lijst) = voorbeeld(block(above: 0.3cm, {
  // Alle getallenlijnen even lang, zodat de 10 onder elkaar staat.
  let getallen = lijst.pos().map(((a, op, b)) => (a, _reken(a, op, b))).flatten()
  let van = calc.min(..getallen) - 1
  let tot = calc.max(..getallen) + 1
  grid(
  columns: (auto, 1fr), column-gutter: 0.6cm, row-gutter: 0.5cm, align: horizon,
  ..lijst.pos().map(((a, op, b)) => {
    let r = _reken(a, op, b)
    (
      _viade10-sommen(a, op, b, (w, br) => _regelvak(br, text(weight: 800, str(w)), fill: white)),
      align(center, box(inset: (x: 0.3cm), getallenlijn(van: van, tot: tot, breedte: 6.2cm,
        labels: range(van, tot + 1), bogen: ((a, 10), (10, r)), boven: 1.4cm))),
    )
  }).flatten(),
  )
}))

// Eén verhaal, twee sommen: de minsom en de plussom die erbij horen.
#let tweesommen(tekst, totaal, deel) = block(breakable: false, above: 0.4cm, below: 0.6cm, {
  let rest = totaal - deel
  tekst
  v(0.15cm)
  [Minsom: #h(0.3cm) #totaal − #deel = #vak(rest) #h(1cm) Plussom: #h(0.3cm) #deel + #vak(rest) = #totaal]
})

// ---------------------------------------------------------------------------
// Geld (hele euro's tot en met 100)
// ---------------------------------------------------------------------------

#let munt(w) = {
  let r = if w == 2 { 0.68cm } else { 0.6cm }
  box(circle(radius: r, stroke: 1pt, inset: 0pt,
    align(center + horizon, circle(radius: r - 0.12cm, stroke: 0.6pt, inset: 0pt,
      align(center + horizon, text(size: 12pt, weight: 800)[€#w])))))
}

#let biljet(w) = {
  let b = 2.2cm + calc.log(w / 5, base: 10) * 0.6cm
  box(width: b, height: 1.25cm, radius: 3pt, stroke: 1pt, inset: 3pt,
    box(width: 100%, height: 100%, stroke: 0.5pt + luma(150), radius: 2pt,
      align(center + horizon, text(size: 15pt, weight: 800)[€ #w])))
}

#let geldstuk(w) = if w <= 2 { munt(w) } else { biljet(w) }

// Een rij munten en biljetten.
#let geld(..stukken) = box(baseline: 40%, grid(columns: stukken.pos().len(), column-gutter: 0.18cm,
  align: horizon, ..stukken.pos().map(geldstuk)))

// Hoeveel is het samen? Elke rij is een lijst van bedragen.
#let hoeveel(nummers: true, ..rijen) = zinnen(ruimte: 0.5cm, nummers: nummers, ..rijen.pos().map(r =>
  [#geld(..r) #h(0.4cm) = #vak(r.sum()) euro]))

// Klopt het bedrag? Elke rij: (bedrag, (stukken)). Omcirkel ja of nee.
#let _keuze(woord, goed) = context box(inset: (x: 8pt, y: 4pt), outset: (y: 3pt), radius: 50%,
  stroke: if goed and _vb.get() { 1.4pt + black }
    else if goed and oplossing { 1.4pt + antwoordkleur } else { none }, strong(woord))
#let kloptbedrag(nummers: true, ..rijen) = zinnen(ruimte: 0.5cm, nummers: nummers, ..rijen.pos().map(((bedrag, stukken)) => {
  let klopt = stukken.sum() == bedrag
  [#geld(..stukken) #h(0.3cm) Is dit #bedrag euro? #h(0.3cm) #_keuze("ja", klopt) #h(0.2cm) #_keuze("nee", not klopt)]
}))

// Betaal met zo min mogelijk geld: per bedrag hoeveel van elk biljet of munt.
#let _soorten = (50, 20, 10, 5, 2, 1)
// `voorbeeld`: een bedrag voor een ingevulde voorbeeldrij bovenaan.
#let zominmogelijk(voorbeeld: none, ..bedragen) = {
  let rij(b) = {
    let rest = b
    let cellen = ()
    for w in _soorten {
      let n = calc.quo(rest, w)
      rest = rest - n * w
      cellen.push(_regelvak(1.2cm, if n > 0 { _antw(str(n)) }))
    }
    (text(size: 16pt, weight: 800)[#b euro], ..cellen)
  }
  table(
    columns: (2.4cm,) + (1fr,) * _soorten.len(),
    align: center + horizon,
    inset: (x: 3pt, y: 6pt),
    stroke: 0.6pt + luma(150),
    table.header([], ..(_soorten.map(w => scale(80%, reflow: true, geldstuk(w))))),
    ..if voorbeeld != none { _voorbeeldrij(() => rij(voorbeeld)) },
    ..bedragen.pos().map(rij).flatten(),
  )
}
