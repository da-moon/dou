# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :consul_manager, ConsulManager.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  cache_static_lookup: false,
  code_reloader: true

config :consul_manager, :multicast_addr, "172.20.20.255"
config :consul_manager, master: true

config :phoenix, :json_library, Jason

#     import_config "#{Mix.env()}.exs"