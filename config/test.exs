use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :retrospectives, Retrospectives.Repo,
  username: "postgres",
  password: "postgres",
  database: "retro_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :retrospectives, :sql_sandbox, true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :retrospectives, RetrospectivesWeb.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :wallaby,
  otp_app: :retrospectives,
  driver: Wallaby.Chrome,
  screenshot_on_failure: true
