#!/bin/bash

set -e -x

bundle exec brakeman
bundle exec bundler-audit
bundle exec rubocop
bundle exec haml-lint app/views
