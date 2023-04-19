# lib/master/master.ex

defmodule ConsulMaster.Node do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def heartbeat do
    GenServer.call(__MODULE__, {:heartbeat})
  end

  def read_config_file(path, mode) do
    Logger.info("Reading file #{path}")
    GenServer.call(__MODULE__, {:read_config_file, path, mode})
  end

  def consul_cluster_init() do
    GenServer.call(__MODULE__, {:consul_cluster_init})
  end

  # GenServer Calls
  def handle_call({:heartbeat}, _from, state) do
    nodes = Node.list()

    result = Enum.map nodes, fn node ->
      case Node.ping(node) do
        :pong ->
          %{node: node, healt: :ok}
        :pang ->
          %{node: node, healt: :nok}
      end

    end

    {:reply, result, state}
  end
  def handle_call({:read_config_file, path, mode}, _from, state) do
    with {:ok, body} <- File.read(path),
      {:ok, config} <- Jason.decode(body) do
        case mode do
          "cluster" ->
            Cache.Server.fetch(:config, config)
            state = Map.put(state, :config, config)
            nodes = Node.list()
            Color.info "Distributing the configuration in all nodes"
            Enum.map nodes, fn node ->
              :rpc.call(node, ConsulNode.Node, :save_cluster_config, [config])
            end
          "service" ->
            Color.info "Registering service"
            {:ok, node} = get_client_node()
            response = :rpc.yield(:rpc.async_call(node, ConsulNode.Node, :register_service, [config]))
            Color.info "Below you will see an array with responses for each registered service"
            process_response(response)
            :rpc.call(node, ConsulNode.Node, :reload_consul_config, [Cache.Server.fetch(:consul_token, nil)])
        end
      {:reply, :ok, state}
    else
      _ ->
        Color.error "Error reading the file"
        {:reply, :error, state}
    end
  end
  def handle_call({:consul_cluster_init}, _from, state) do
    nodes = Node.list()
    case Cache.Server.get(:config) do
      {:found, config} ->
        Color.info "\n Validating if we have enough nodes to create the cluster"
        {size, _} = Integer.parse(config["size"])
        if size > length(nodes) do
          Logger.error "Warning! Not enough nodes"
        else
          Logger.info "Enough nodes to proceed"
        end

        Color.info "\n Creating a cluster with this specifications"
        Color.marked inspect(config)

        length = 43
        key = :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
        encrypt_key = key <> "="
        work_on_nodes(:consul_service, [encrypt_key])

        if config["consul_features"]["bootstrap_acl"] do
          Color.info "Bootstrap ACL enabled"
          start_bootstrap_acl(nodes)
        end
      {:not_found} ->
        Logger.error "No config provided"
        Logger.warn "Run ConsulMaster.Node.read_config_file(\"path/to/file\")"
        exit(:shutdown)
    end

    {:reply, :ok, state}
  end

  defp node_name(pnode) do
    name = pnode |> inspect() |> String.replace("\"", "") |> String.split(["@", ":"]) |> Enum.at(1)
    { :ok, name }
  end

  defp get_client_node() do
    nodes = Node.list
    node = Enum.find nodes, fn node ->
      match?({:ok, "client"}, node_name(node))
    end
    {:ok, node}
  end

  defp start_bootstrap_acl(nodes) do
    Color.info "Getting the leader of cluster..."
    :timer.sleep(10000)
    def_hostname = nodes |> Enum.at(1) |> inspect() |> String.replace("\"", "") |> String.split(["@", ":"]) |> Enum.at(2)
    consul_url = "http://" <> def_hostname <> ":8500"

    response = HTTPoison.get!(consul_url <> "/v1/status/leader")

    case response.status_code do
      200 ->
        body = Poison.decode!(response.body)
        Color.ok "Leader elected " <> body
        leader_ip = String.replace(body, "8300", "8500")
        leader_node = "server@" <> String.replace(leader_ip, ":8500", "") |> String.to_atom

        Color.info "Starting Bootstrap ACL"
        rootToken = :rpc.call(leader_node, ConsulNode.Node, :bootstrap_acl, [leader_ip])
        Cache.Server.fetch(:consul_token, rootToken)
        Color.ok "Token saved in Master's Cache"

        Color.info "Distributing the token in the cluster"
        work_on_nodes(:reload_consul_config, [rootToken])
      500 ->
        exit("No leader found. Try again")
    end
  end

  defp work_on_nodes(function, params) do
    nodes = Node.list()

    Enum.map nodes, fn node ->
      {:ok, name} = node_name(node)
      case name do
        "server" ->
          Color.info "Working node: Server " <> inspect(node)
          response = :rpc.yield(:rpc.async_call(node, ConsulNode.Node, function, params))
          process_response(response)
        "client" ->
          Color.info "Working node: Client " <> inspect(node)
          response = :rpc.yield(:rpc.async_call(node, ConsulNode.Node, function, params))
          process_response(response)
      end
    end
  end

  defp process_response(response) do
    case response do
      {:reply, :ok} ->
        Color.ok "Service started succesfully on node ^"
      [_] -> 
        Color.warning inspect(response)
      :ok ->
        Color.ok "Configuration reloaded ^"
      {:badrpc, value} ->
        case value do
          {:EXIT, error} ->
            Color.error inspect(error)
          _ ->
            Color.error inspect(value)
        end
      _ ->
        Color.error inspect(response)
    end
  end
end
