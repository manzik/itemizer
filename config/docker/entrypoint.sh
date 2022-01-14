#!/bin/bash

# Strict mode: Exit immediately if a single command exits with a non-zero status.
set -e

# Clean up leftover server pid file if it exists
if [ -f /itemizer/tmp/pids/server.pid ]; then
  rm /itemizer/tmp/pids/server.pid
fi

# In case not already done:
# Creates the database
# Loads the schema and runs the migrations
# Initializes the database with the seed data
rails db:prepare

# Run the server
bundle exec puma -C config/puma.rb