# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :real_world,
  ecto_repos: [RealWorld.Repo]

# Configures the endpoint
config :real_world, RealWorldWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6ttwKNFF3y23eFg977N2UktCPNmV4S+CqsWEIIdtj9aoF4dX9N6umNNV918On0fJ",
  render_errors: [view: RealWorldWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: RealWorld.PubSub,
  live_view: [signing_salt: "QrZ1oedl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :real_world, RealWorld.Guardian,
  issuer: "real_world",
  secret_key: "mjHO9Rj6PbkIds7aTf33VCZ+NTyWWsYM0zhYdVn1+JbIUC6fcgimO9Tpa8a5UJj9"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
