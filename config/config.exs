# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :quickcourt_backend,
  ecto_repos: [QuickcourtBackend.Repo]

# Configures the endpoint
config :quickcourt_backend, QuickcourtBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Vv0S75ggobQs379OoSqT13vA8bYfxq1POYHxDJvOA181NhMOECW+3Ka5Ys81luE8",
  render_errors: [view: QuickcourtBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: QuickcourtBackend.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# PDF generator X server
{os_family, os_name} = :os.type()

if Atom.to_string(os_family) == "unix" do
  config :pdf_generator,
    command_prefix: ["xvfb-run", "-a"]
end

# Guardian config details
# to generate secrete run: mix guardian.gen.secret
config :quickcourt_backend, QuickcourtBackend.Guardian,
       issuer: "quickcourt_backend",
       secret_key: "ToPI7ruKGB3nQmfn4QeDiFsgbofgFwBY4Ea0EcdzL9W0k123eAXyKbS8KDO0vILs"

config :porcelain, driver: Porcelain.Driver.Basic
