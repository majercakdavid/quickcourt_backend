use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :quickcourt_backend, QuickcourtBackendWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :quickcourt_backend, QuickcourtBackend.Repo,
  username: "postgres",
  password: "postgres",
  database: "quickcourt_backend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
