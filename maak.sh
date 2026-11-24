#!/bin/sh
# Maakt een pdf van een blad, naast het .typ-bestand.
#
#   sh maak.sh mijn/rekenen.typ              -> mijn/rekenen.pdf
#   sh maak.sh mijn/rekenen.typ antwoorden   -> mijn/rekenen-antwoorden.pdf
#
# Werkt vanuit elke map; het script regelt --root en --font-path zelf.

set -eu

if [ $# -lt 1 ]; then
  echo "Gebruik: sh maak.sh pad/naar/blad.typ [antwoorden]" >&2
  exit 1
fi

project=$(cd "$(dirname "$0")" && pwd)
blad=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
uit=${blad%.typ}

if [ ! -f "$project/fonts/Nexa-Heavy.ttf" ] || [ ! -f "$project/fonts/lusletters.ttf" ]; then
  echo "De lettertypen ontbreken; ik haal ze eerst op."
  sh "$project/fonts/ophalen.sh"
fi

if [ "${2:-}" = "antwoorden" ]; then
  typst compile --root "$project" --font-path "$project/fonts" --input oplossing=ja "$blad" "$uit-antwoorden.pdf"
  echo "Klaar: $uit-antwoorden.pdf"
else
  typst compile --root "$project" --font-path "$project/fonts" "$blad" "$uit.pdf"
  echo "Klaar: $uit.pdf"
fi
