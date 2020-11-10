#!/usr/bin/env bash

set -euxo pipefail

###################################

rm -rfd ./app/Api
./node_modules/.bin/purescript-graphql-client-generator \
  --input-json ./schemas/schema.json --output ./app/Api --api Api
