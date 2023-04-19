defmodule ConsulManager.Endpoint do
  use Phoenix.Endpoint, otp_app: :consul_manager

  socket "/socket", ConsulManager.UserSocket


  # Serve at "/" the given assets from "priv/static" directory
  plug Plug.Static,
    at: "/", from: :consul_manager,
    only: ~w(css images js favicon.ico robots.txt)

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.CodeReloader
    plug Phoenix.LiveReloader
  end


  plug Plug.Logger

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_consul_manager_key",
    signing_salt: "LH6XmqGb",
    encryption_salt: "CIPZg4Qo"

end