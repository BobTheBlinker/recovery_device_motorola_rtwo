#!/bin/bash
# AERA device callback for rtwo.
# prepdecrypt mounts system/vendor via by-name; on rtwo they live in super,
# so point it at the dm-mapper nodes first (falls back to by-name).
RD="$1"
[ "$2" = "--first-call" ] || exit 0
F="$RD/system/bin/prepdecrypt.sh"
[ -f "$F" ] || exit 0
sed -i -E 's#^([[:space:]]*)(sys|ven)path="/dev/block/bootdevice/by-name/(system|vendor)\$suffix"$#\1\2path="/dev/block/mapper/\3$suffix"; [ -e "$\2path" ] || \2path="/dev/block/bootdevice/by-name/\3$suffix"#' "$F"
echo "-- rtwo callback: prepdecrypt -> $(grep -c 'dev/block/mapper' "$F") mapper paths"
