use Mix.Config

config :consul_manager, ConsulManager.Endpoint,
  url: [host: "localhost"],
  root: Path.expand("..", __DIR__),
  secret_key_base: "/RjKJmMO6raXPRTq63qTqid1x6lVKTOP+FTxZHfX6Ogd+1xYmH6eZZFhBu1CIwtg",
  debug_errors: false,
  pubsub_server: ConsulManager.PubSub

config :logger,
  backends: [
    {ConsulManager.Console, :json}
  ]
config :logger, :json,
  level: :debug
  # style: :line

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
