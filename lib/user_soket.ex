defmodule ConsulManager.UserSocket do
  use Phoenix.Socket

  channel "rooms:*", ConsulManager.RoomChannel

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end