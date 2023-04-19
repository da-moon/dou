# lib/link_cache/supervisor.ex
defmodule ConsulMaster.Supervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(ConsulMaster.Node, [[name: ConsulMaster.Node]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
