defmodule Watcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    {:ok, watcher_pid} = FileSystem.start_link(dirs: ["/Users/admin/workspace/consul-manager/consul_config/log"])
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid}=state) do
    # YOUR OWN LOGIC FOR PATH AND EVENTS
    IO.puts inspect(path)
    IO.puts inspect(events)
    {:reply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid}=state) do
    # YOUR OWN LOGIC WHEN MONITOR STOP
    {:reply, state}
  end
end