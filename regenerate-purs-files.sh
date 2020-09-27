#!/usr/bin/env bash

set -euxo pipefail

###################################

generate-halogen-css-modules -d ./app

###################################

update-module-name-purs -d ./src
update-module-name-purs -d ./app
