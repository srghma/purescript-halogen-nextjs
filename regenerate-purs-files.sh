#!/usr/bin/env bash

set -euxo pipefail

###################################

generate-halogen-css-modules -d ./app

###################################

update-module-name-purs -d ./src -d ./app -d ./webpack
