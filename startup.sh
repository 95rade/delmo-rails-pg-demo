#!/bin/bash

until rails db:create
do
    echo "."
    sleep 1
done
sleep 2

rails db:create

env
rails db:migrate:status

set -e
rails db:migrate

rm -f tmp/pids/server.pid
bundle exec rails s -p 3000 -b '0.0.0.0'
