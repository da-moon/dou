# lib/consul_node/node.ex

defmodule ConsulNode.Node do
  use GenServer
  @ccc "consul_scripts/create_consul_config.sh"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def save_master(master_info) do
    GenServer.call(__MODULE__, {:save_master, master_info})
  end
  
  def save_cluster_config(cluster_info) do
    GenServer.call(__MODULE__, {:save_cluster_config, cluster_info})
  end
  
  def return_hostname do
    GenServer.call(__MODULE__, {:return_hostname})
  end
  
  def consul_service(encrypt_key) do
    GenServer.call(__MODULE__, {:consul_service, encrypt_key})
  end

  def end_consul_service do
    GenServer.call(__MODULE__, {:end_consul_service})
  end

  def bootstrap_acl(consul_url) do
    GenServer.call(__MODULE__, {:bootstrap_acl, consul_url})
  end

  def reload_consul_config(rootToken) do
    GenServer.call(__MODULE__, {:reload_consul_config, rootToken})
  end

  def register_service(configuration) do
    GenServer.call(__MODULE__, {:register_service, configuration})
  end

  # GenServer Calls
  def handle_call({:save_master, master_info}, _from, state) do
    Cache.Server.fetch(:master, master_info)

    {:reply, :ok, state}
  end
  def handle_call({:save_cluster_config, cluster_info}, _from, state) do
    Cache.Server.fetch(:config, cluster_info)

    {:reply, :ok, state}
  end
  def handle_call({:return_hostname}, _from, state) do
    hostname = Node.self |> inspect |> String.replace("\"", "") |> String.split(["@", ":"]) |> Enum.at(2)

    {:reply, hostname, state}
  end
  def handle_call({:consul_service, encrypt_key}, _from, state) do
    case create_config_file(encrypt_key) do
      {:ok} ->
        Color.ok "HCL file created succesfully\nStarting service..."
        response = start_consul_service()
        {:reply, response, state}
      {:error, reason} -> Color.error(reason)
    end
  end
  def handle_call({:end_consul_service}, _from, state) do
    pid = Cache.Server.fetch(:consul_service_info, nil).os_pid
    System.cmd("kill", ["-9", pid])

    {:reply, "Consul service ended gracefully", state}
  end
  def handle_call({:bootstrap_acl, consul_url}, _from, state) do
    Cache.Server.fetch(:consul_url, consul_url)

    case http_call(consul_url <> "/v1/acl/bootstrap", "PUT", [], []) do
      {200, acl_body} -> 
        body = Poison.decode!(acl_body)
        rootToken = body["SecretID"]
        Color.default "\n Bootstrap ACL Finished. Saving root token in Cache and KV Store"

        Cache.Server.fetch(:consul_token, rootToken)
        Color.ok "Token saved in Cache"

        headers = ["X-Consul-Token": rootToken]
        case http_call(consul_url <> "/v1/kv/rootToken", "PUT", rootToken, headers) do
          {_kv_code, "true"} ->
            Color.ok "Token saved in Consul KV Store"
            
          {_kv_code, error} ->
            Color.error"\n Error: " <> error
            Color.error"\n Token not saved in Consul KV Store. Here is your token " <> rootToken
        end
        
        {:reply, rootToken, state}
      {_, error} -> Color.error(error) 
    end
  end
  def handle_call({:reload_consul_config, rootToken}, _from, state) do
    rcc = "consul_scripts/recreate_consul_config.sh" 

    case Cache.Server.get(:consul_url) do
      {:found, url} -> 
        consul_url = url
      {:not_found} -> 
        hostname = Node.self |> inspect |> String.replace("\"", "") |> String.split(["@", ":"]) |> Enum.at(2)
        consul_url = "http://" <> hostname <> ":8500"
        Cache.Server.fetch(:consul_url, consul_url)
    end
    F.write_file_and_concat(
      rcc,
      ["export CONSUL_HTTP_TOKEN=#{inspect(rootToken)}"],
      [:add_newlines],
      @ccc
    )

    Color.default "Adding token to configuration file"
    
    headers = ["X-Consul-Token": rootToken]
    {_output, _error_code} = System.cmd("sh", [rcc], [stderr_to_stdout: true])
    
    {status_code, _consul_reload} = http_call(Cache.Server.fetch(:consul_url, nil) <> "/v1/agent/reload", "PUT", [], headers)
    Color.ok "Configuration reloaded"
    {:reply, :ok, state}
  end
  def handle_call({:register_service, configuration}, _from, state) do
    Color.default "\n Creating HCL configuration file"

    ccs = "consul_scripts/create_config_service.sh"
    host_ip = Node.self |> inspect |> String.replace("\"", "") |> String.split(["@", ":"]) |> Enum.at(2)
    rootToken = Cache.Server.fetch(:consul_token, nil)
    services = configuration["services"]
    results = Enum.map services, fn service ->
      name = service["name"]
      port = service["port"]
      tags = "[]"

      F.write_file(
        ccs,
        [
          "export SERVICE_NAME=#{inspect(name)})",
          "export PORT=#{inspect(port)})",
          "export TAGS=#{inspect(tags)})",
          "export HOST_IP=#{inspect(host_ip)})",
          "export CONSUL_HTTP_TOKEN=#{inspect(rootToken)})\n",
          "consul-template -template \"consul_config/services.json.tmpl:consul_config/service_#{name}.hcl\" -once"
        ],
        [:append, :add_newlines]
      )
      
      {output, status_code} = System.cmd("sh", [@ccs], [stderr_to_stdout: true])
      case status_code do
        0 -> {:ok}
        _ -> {output}
      end
    end

    {:reply, results, state}
  end

  defp create_config_file(encrypt_key) do
    Color.default "\n Creating HCL configuration file"

    configuration = Cache.Server.fetch(:config, nil)

    datacenter = configuration["clusterName"]
    size = configuration["size"]
    features = configuration["consul_features"]
    acl = features["bootstrap_acl"]
    vault_backend = features["vault_backend"]

    nodes = Node.list()
    result = Enum.map nodes, fn node ->
      :rpc.call(node, ConsulNode.Node, :return_hostname, [])
    end

    node_string = Node.self |> inspect |> String.replace("\"", "") |> String.split(["@", ":"])

    hostname = node_string |> Enum.at(2)
    name = Enum.at(node_string, 1) <> Enum.at(String.split(hostname, "."), 3)
    server = if Enum.at(node_string, 1) === "server", do: true, else: false

    F.write_file(
      @ccc,
      [
        "export CONSUL_SERVERS=#{inspect(size)}",
        "export HOST_IP=#{inspect(hostname)}",
        "export DATACENTER=#{inspect(datacenter)}",
        "export NAME=#{inspect(name)}",
        "export SERVER=#{inspect(server)}",
        # IO.binwrite(conf_file, "\nexport HOST_LIST=" <> inspect(result)) # TODO: Export an array
        "export CONSUL_ENCRYPT_KEY=#{inspect(encrypt_key)}",
        "export ACL=#{inspect(acl)}\n",
        "consul-template -template \"consul_config/consul.hcl.tmpl:consul_config/consul.hcl\" -once"
      ],
      [:append, :add_newlines]
    )

    {output, status_code} = System.cmd("sh", [@ccc], [stderr_to_stdout: true])

    case status_code do
      0 -> {:ok}
      _ -> {:error, output}
    end
  end
  
  defp start_consul_service() do
    case validate_configuration() do
      {:ok} ->
        consul_service_info = Port.info(Port.open({:spawn, 
          "consul agent -config-dir=" <> WD.get_consul_config_dir <> ">>" <> WD.get_consul_log <> " 2>&1"
          }, [:binary]))

        Cache.Server.fetch(:consul_service_info, consul_service_info)
        Color.default "Service started succesfully"
        {:reply, :ok}
      {:error, reason} -> 
        Color.error "Error: " <> inspect(reason)
        {:reply, reason}
    end
  end

  defp validate_configuration() do
    {output, status_code} = System.cmd("consul", ["validate", WD.get_consul_config], stderr_to_stdout: true)

    case status_code do
      0 -> {:ok}
      _ -> {:error, output}
    end
  end

  defp http_call(url, method, data, headers) do
    response = cond do
      method == "GET" ->
         HTTPoison.get!(url, headers)
      method == "PUT" ->
         HTTPoison.put!(url, data, headers)
      method == "POST" ->
         HTTPoison.post!(url, data, headers)
      method == "DELETE" ->
         HTTPoison.delete!(url, headers)
    end

    req = response.body
    status_code = response.status_code

    {status_code, req}
  end

end
