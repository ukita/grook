# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :grook,
  ecto_repos: [Grook.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :grook, Grook.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3vackRJ/q5Mh4U9oXVxbytELxNHzFOQzmd6YwxrTysGoL9c6ybzc6moY7ZEmvbXf",
  render_errors: [view: Grook.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Grook.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Grook",
  ttl: { 30, :days },
  allowed_drift: 2000,
  secret_key: "xpz7fwHCYe4hVzsCVR1aq11TDIlSc74v5TgjgfCmj8TpgeVXt+D7/tBuibczWrdz",
  serializer: Grook.Guardian.Serializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
