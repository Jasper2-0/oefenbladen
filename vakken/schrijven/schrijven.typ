// Schrijven (Pennenstreken, verbonden schrift). Bevat ook alles uit
// kern/opmaak.typ.
//
// Voorbeeldletters in Lusletters (fonts/lusletters.ttf, Liesbeth Flobbe,
// SIL Open Font License 1.1, https://syboor.eu/fonts/lusletters/), de variant
// die syboor.eu aanraadt naast Pennenstreken (2e editie en later), met
// stylistic set 8 voor de hoofdletter R. De letters worden automatisch
// verbonden; lang: "nl" zorgt voor de ij.
//
// Lineatuur: vier lijnen. Grondlijn (dik), middenlijn (bovenkant van de
// kleine letters), bovenlijn (lussen en hoofdletters) en onderlijn. Lus- en
// staartzone zijn 1,5 keer zo hoog als de middenzone, zoals in de letter.
// `romp` is de hoogte van de middenzone; nog afstemmen op het schrift.

#import "/kern/opmaak.typ": *

#let schrijfletter = "Lusletters"
#let romp = 0.5cm

// Lettergrootte waarbij de x-hoogte van Lusletters precies `romp` is
// (x-hoogte = 0,35 cm bij 40 pt).
#let _lusgrootte(romp) = 40pt * (romp / 0.35cm)

#let _lus(body, romp, kleur: black) = text(
  font: schrijfletter, size: _lusgrootte(romp), lang: "nl", stylistic-set: 8,
  top-edge: "ascender", bottom-edge: "descender", fill: kleur, body)

// Eén schrijfregel met lineatuur, eventueel met tekst erop.
#let schrijfregel(body: none, kleur: black, romp: romp) = {
  let lus = romp * 1.5
  let h = lus + romp + lus
  block(width: 100%, height: h, above: 0.25cm, below: 0.25cm, {
    let y-boven = 0pt
    let y-midden = lus
    let y-grond = lus + romp
    place(top + left, line(start: (0pt, y-boven), end: (100%, y-boven), stroke: 0.4pt + luma(170)))
    place(top + left, line(start: (0pt, y-midden), end: (100%, y-midden), stroke: (paint: luma(150), thickness: 0.5pt, dash: "dashed")))
    place(top + left, line(start: (0pt, y-grond), end: (100%, y-grond), stroke: 1pt + luma(60)))
    place(top + left, line(start: (0pt, h), end: (100%, h), stroke: 0.4pt + luma(170)))
    // De romp licht gekleurd, zodat de middenzone opvalt.
    place(top + left, dy: y-midden, rect(width: 100%, height: romp, fill: luma(246), stroke: none))
    if body != none {
      place(top + left, dx: 0.2cm, _lus(body, romp, kleur: kleur))
    }
  })
}

// Naschrijven: voorbeeld, een regel om over te trekken (grijs) en lege regels.
#let naschrijven(body, leeg: 2, overtrekken: true, romp: romp) = block(breakable: false, {
  schrijfregel(body: body, romp: romp)
  if overtrekken { schrijfregel(body: body, kleur: luma(185), romp: romp) }
  for _ in range(leeg) { schrijfregel(romp: romp) }
})

// Eén letter of cijfer oefenen: vooraan het voorbeeld (zwart), daarna
// `keer` keer grijs om over te trekken, en `leeg` lege regels.
#let oefenrij(model, keer: 4, leeg: 1, afstand: 0.9cm, romp: romp) = block(breakable: false, {
  schrijfregel(romp: romp, body: {
    model
    h(afstand)
    text(fill: luma(185), range(keer).map(_ => model).join(h(afstand)))
  })
  for _ in range(leeg) { schrijfregel(romp: romp) }
})

// ---------------------------------------------------------------------------
// Groep 3: één letter per werkblad, in de volgorde van Veilig Leren Lezen
// ---------------------------------------------------------------------------
//
// Opbouw zoals het schrijfboek van groep 3: eerst de letter (groot, dan op de
// lijn), op de tweede pagina woorden en een zinnetje. De woorden komen uit
// methoden/vll/kernen.yaml en bevatten alleen letters die het kind al kent.

// Grotere middenzone voor groep 3; geschat uit het schrijfboek, nog nameten.
#let romp-groep-3 = 0.7cm

// Klanken van meer dan één letter, langste eerst.
#let _meer = ("sch", "aa", "ee", "oo", "oe", "ij", "uu", "eu", "ie", "ou", "au", "ui", "ei", "ng", "ch")

// Een woord in klanken: "boot" → ("b", "oo", "t").
#let klanken(woord) = {
  let uit = ()
  let rest = woord
  while rest.len() > 0 {
    let k = _meer.find(m => rest.starts-with(m))
    if k == none { k = rest.clusters().first() }
    uit.push(k)
    rest = rest.slice(k.len())
  }
  uit
}

// De letters die het kind kent als `letter` van kern `k` aan de beurt is:
// alle letters van de kernen ervoor en van kern k tot en met `letter`.
#let bekende-letters(kernen, k, letter) = {
  let uit = ()
  for (naam, kern) in kernen {
    for l in kern.letters {
      uit.push(l)
      if naam == k and l == letter { return uit }
    }
  }
  uit
}

// Tot `aantal` woorden met `letter` erin en verder alleen bekende letters.
// Eerst de woorden van kern k (plaatjeswoorden voorop), dan eerdere kernen.
#let schrijfwoorden(kernen, k, letter, aantal: 3) = {
  let kent = bekende-letters(kernen, k, letter)
  let namen = kernen.keys()
  let tot = namen.slice(0, namen.position(n => n == k) + 1).rev()
  let uit = ()
  for n in tot {
    for w in kernen.at(n).woordjes + kernen.at(n).oefen {
      let kl = klanken(w)
      if letter in kl and kl.all(x => x in kent) and w not in uit and uit.len() < aantal {
        uit.push(w)
      }
    }
  }
  uit
}

// Controle voor een eigen zinnetje: alleen bekende letters, anders een fout.
#let _controleer(zin, kent) = {
  for w in zin.split(regex("[^a-z]+")).filter(w => w != "") {
    let vreemd = klanken(w).filter(x => x not in kent)
    assert(vreemd.len() == 0, message: "'" + w + "' heeft letters die nog niet gehad zijn: " + vreemd.join(", "))
  }
}

// Werkblad voor één letter: pagina 1 de letter, pagina 2 woorden en zinnetje.
#let letterblad(nummer, kernen, k, letter, zin: none, extra: (), romp: romp-groep-3) = {
  let kent = bekende-letters(kernen, k, letter)
  for w in extra { _controleer(w, kent) }
  if zin != none { _controleer(zin, kent) }
  let woorden = schrijfwoorden(kernen, k, letter)
  woorden = (woorden + extra.filter(w => w not in woorden)).slice(0, calc.min(3, woorden.len() + extra.len()))
  [
    #werkblad(nummer, [De letter #letter], soort: "Schrijfblad")

    #opdracht(1, [Groot],
      instructie: [Trek de grote letters over: eerst met je vinger, dan met je potlood.],
    )[
      #oefenrij(letter, keer: 3, leeg: 0, afstand: 1.6cm, romp: 1cm)
    ]

    #opdracht(2, [Op de lijn],
      instructie: [Trek de grijze letters over. Schrijf daarna zelf.],
    )[
      #oefenrij(letter, keer: 5, leeg: 2, romp: romp)
    ]
  ]
  if woorden.len() > 0 or zin != none [
    #nieuwepagina()

    #if woorden.len() > 0 [
      #opdracht(3, [Woorden],
        instructie: [Trek de woorden over. Schrijf ze daarna zelf.],
      )[
        #naschrijven(leeg: 1, romp: romp, woorden.join(h(1.3cm)))
      ]
    ]

    #if zin != none [
      #opdracht(if woorden.len() > 0 { 4 } else { 3 }, [Een zinnetje],
        instructie: [Trek het zinnetje over. Schrijf het daarna zelf.],
      )[
        #naschrijven(leeg: 1, romp: romp, zin)
      ]
    ]
  ]
}
