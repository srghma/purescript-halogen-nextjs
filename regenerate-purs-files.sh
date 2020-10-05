#!/usr/bin/env bash

set -euxo pipefail

###################################

generate-halogen-css-modules -d ./app

###################################

sd --flags c "^import ([\w\.]+) (\(.+\) )as ([\w\.]+)" 'import $1 as $3' $(fd --type f ".purs" ./)

update-module-name-purs -d ./src -d ./app -d ./webpack

