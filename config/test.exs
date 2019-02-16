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
  username: "quickcourt",
  password: "quickcourt",
  database: "quickcourt_dev",
  hostname: "192.168.99.100",
  pool: Ecto.Adapters.SQL.Sandbox
