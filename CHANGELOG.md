# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.1-dev]

### Fixed

- Remove redundant config naming to just `config :drill, :otp_app, :my_app`

### Added

- Allow user to set `on_conflict` strategy using optional callback `on_conflict/0`
- Require seeder files to be .exs
- Allow user to set `timeout` through config. E.g. `config :drill, :timeout, :infinity`

## [1.0.0] - 2023-06-14

### Changed

- Upgrade Elixir & Erlang tool versions to 1.14.5-otp-25 and 25.3.2, respectively

### Added

- Add new required callback `factory/0`
- Add new functions `seed/0` & `seed/1` that return `Drill.Seed` struct
- Require `run/0` callback to always return a list of `Drill.Seed` struct

## [0.1.1] - 2022-05-28

### Fixed

- Remove Drill.Demo.Repo from being run on dev
- Rename module with `Demo` to `Test` (e.g. `Drill.Demo.Repo` is renamed to `Drill.Test.Repo`)
