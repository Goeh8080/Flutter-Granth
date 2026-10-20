#!/usr/bin/env bash
# Standalone sample; not part of the app build.
set -euo pipefail
i=1
for g in "गीता" "कबीर सागर" "वेद"; do
  echo "$i. $g"
  i=$((i + 1))
done
# Granth list sample — prints titles in order.
# Granth list sample Granth list sam
