import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :drill, Drill.Test.Repo,
  username: "postgres",
  password: "postgres",
  database: "drill_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :drill, ecto_repos: [Drill.Test.Repo]

# Print only warnings and errors during test
config :logger, level: :warn
