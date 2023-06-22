# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

- Add `:repo` to `Drill.Context`
- Allow user to override location of seeder file through `seeds_path` option when running `mix drill`. E.g. `mix drill -r MyApp.Repo --seeds-path priv/seeds/core`
- Allow manual seeds and set callback `factory/0` to optional

## [1.1.0] - 2023-06-16

### Added

- Allow user to set `on_conflict` strategy using optional callback `on_conflict/0`
- Require seeder files to be .exs and remove the need to config `:otp_app`
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
