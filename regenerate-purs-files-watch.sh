#!/usr/bin/env bash

set -euxo pipefail

chokidar "./src/**/*.purs" -c "update-module-name-purs -d ./src" &
chokidar "./app/**/*.purs" -c "update-module-name-purs -d ./app && generate-halogen-css-modules -d ./app" &
chokidar "./webpack/**/*.purs" -c "update-module-name-purs -d ./webpack" &
