// Voorbeeld woordkaartjes uit woorden.yaml: voorkant het woord, achterkant de
// betekenis. Dubbelzijdig printen, omslaan langs de lange zijde, op 100%.
#import "/vakken/taal/taal.typ": *

#woordkaartjes(yaml("woorden.yaml"), thema: "Op de boerderij")
