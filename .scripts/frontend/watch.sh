#!/usr/bin/env bash
set -e

ASSET_HASH=assets \
ENVIRONMENT=local \
PUBLIC_DEST=public \
WEBPACK_MODE=development \
.scripts/frontend/webpack.sh
