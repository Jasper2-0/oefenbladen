#!/bin/sh
# Haalt de lettertypen op die niet in deze repo staan en zet ze in fonts/.
# Gebruik (vanuit de projectmap):  sh fonts/ophalen.sh
#
# - Nexa Heavy (koppen): Fontfabric, via DaFont, "gratis voor privégebruik".
#   Lees de licentie van Fontfabric (https://www.fontfabric.com) voordat je
#   het font voor iets anders gebruikt. Daarom staat het niet in de repo.
# - Lusletters (schrijfletter): Liesbeth Flobbe, SIL Open Font License 1.1,
#   https://syboor.eu/fonts/lusletters/
#
# Elk bestand wordt gecontroleerd met een sha256-checksum. Klopt die niet
# (de bron heeft een andere versie), dan stopt het script.
#
# Avenir en Futura zijn systeemfonts van macOS en worden niet opgehaald.

set -eu

map=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

sha() {
  if command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1
  else sha256sum "$1" | cut -d' ' -f1; fi
}

controleer() { # bestand verwachte-checksum
  echo "$2  $(basename "$1")"
  if [ "$(sha "$1")" != "$2" ]; then
    echo "Checksum klopt niet voor $(basename "$1"); de bron is veranderd." >&2
    exit 1
  fi
}

if [ ! -f "$map/Nexa-Heavy.ttf" ]; then
  echo "Nexa Heavy ophalen (DaFont) ..."
  curl -fsSL -o "$tmp/nexa.zip" "https://dl.dafont.com/dl/?f=nexa"
  unzip -q -o "$tmp/nexa.zip" Nexa-Heavy.ttf -d "$tmp"
  controleer "$tmp/Nexa-Heavy.ttf" 8bd502de7aa8a568f62ef694969949fcdd5a7a60265607381da31328c61bddfe
  mv "$tmp/Nexa-Heavy.ttf" "$map/"
fi

if [ ! -f "$map/lusletters.ttf" ]; then
  echo "Lusletters ophalen (syboor.eu) ..."
  curl -fsSL -o "$tmp/lusletters.ttf" "https://syboor.eu/fonts/lusletters/lusletters.ttf"
  controleer "$tmp/lusletters.ttf" d7c340d2b0150fb8eeec480038b49dbfa3e205cba7db3f4aebadab233f848c8c
  mv "$tmp/lusletters.ttf" "$map/"
fi

echo "Klaar. Fonts in $map:"
ls "$map" | grep -E '\.(ttf|otf)$'
