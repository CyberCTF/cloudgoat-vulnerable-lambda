#!/bin/sh
# The deployment's cgid, made once ("vulnerable_lambda_cgid" and ten random characters, as
# CloudGoat's CLI makes it) and kept in <file> until `isoloom down` removes it, in the JSON
# Terraform's `external` data source reads. Usage: cgid.sh <file>
set -eu
f=$1
if [ ! -s "$f" ]; then
  printf 'vulnerable_lambda_cgid%s\n' "$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 10)" >"$f"
fi
printf '{"cgid":"%s"}\n' "$(cat "$f")"
