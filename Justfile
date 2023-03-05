set dotenv-load

black := "poetry run black"
isort := "poetry run isort --profile black --filter-files"

# List all the tasks
list:
  @just --list --unsorted

# Install dependencies
install:
  poetry install

# Launch the development server
dev:
  poetry run flask --app applier run

# Launch a background task worker
tasks:
  poetry run dramatiq -p 1 -t 1 applier

# Open a python shell
shell:
  poetry run ipython

# Build the project
build:
  rm -rf dist
  poetry build

# Lint the project
lint:
  poetry check
  poetry lock
  {{black}} .
  {{isort}} .

alias l := lint

# Run tests in CI
ci:
  poetry check
  poetry lock --check
  {{black}} --check --diff .
  {{isort}} --check-only --diff .

# Publish a new version
publish kind:
  #!/usr/bin/env bash

  version=$(poetry version {{kind}} -s)

  git add pyproject.toml
  git commit -m "chore: bump version"
  git push

  git tag v$version
  git push --tags
