#!/bin/sh

set -e

DB=${DB_HOST:-datahub-tmb-database-postgres:5432}

dockerize -wait tcp://$DB -timeout 30s

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# npm set audit false
bundle exec rake db:migrate

# bundle exec rake assets:precompile
cp -r /app/public/* /assets/


exec "$@"
