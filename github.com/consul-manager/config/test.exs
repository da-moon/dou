use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :consul_manager, ConsulManager.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :consul_manager, :multicast_addr, "192.168.50.255"
config :consul_manager, master: true
