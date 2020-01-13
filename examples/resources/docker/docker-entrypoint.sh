#!/bin/bash

set -ex

# Check or install the app dependencies via Bundler:
bundle check || bundle

# Specify a default command, in case it wasn't issued:
if [ -z "$1" ]; then
  set -- bundle exec rails s -b 0.0.0.0 -p 3000 "$@"
fi

# Execute the given or default command:
exec "$@"

