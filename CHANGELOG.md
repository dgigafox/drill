# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.1.1] - 2022-05-28

### Fixed

- Remove Drill.Demo.Repo from being run on dev
- Rename module with `Demo` to `Test` (e.g. `Drill.Demo.Repo` is renamed to `Drill.Test.Repo`)

## [1.0.0-dev] - 2023-06-14

- Upgrade Elixir & Erlang tool versions to 1.14.5-otp-25 and 25.3.2, respectively
- Add new required callback `factory/0`
- Add new functions `seed/0` & `seed/1` that return `Drill.Seed` struct
- Require `run/0` callback to always return a list of `Drill.Seed` struct
