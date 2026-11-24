// Voorbeeld woordenschatbingo met de woorden uit woorden.yaml (minstens 16).
// Pagina 1: spelregels en voorleeslijst; daarna de bingokaarten.
#import "/vakken/taal/taal.typ": *

#show: oefenbladen.with(groep: 4, thema: "Op de boerderij", soort: "Woordenschatbingo")

#bingo(yaml("woorden.yaml"), thema: "Op de boerderij", kaarten: 4)
