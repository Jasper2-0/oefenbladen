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
