defmodule ConsulManager do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    m_addr = Application.fetch_env!(:consul_manager, :multicast_addr)

    topologies = [
      consul_manager: [
        strategy: Cluster.Strategy.Gossip,
        config: [
          multicast_addr: m_addr,
        ],
      ]
    ]

    children = [
      # Start the endpoint when the application starts
      {Phoenix.PubSub, [name: ConsulManager.PubSub, adapter: Phoenix.PubSub.PG2]},
      {Cluster.Supervisor, [topologies, [name: ConsulManager.ClusterSupervisor]]},
      supervisor(ConsulManager.Endpoint, []),
      supervisor(Cache.Supervisor, []),
      
      # Here you could define other workers and supervisors as children
      # worker(ConsulManager.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConsulManager.Supervisor]
    Supervisor.start_link(children, opts)

    case Application.fetch_env!(:consul_manager, :master) do
      true -> 
        Supervisor.start_link([supervisor(ConsulMaster.Supervisor, [])], strategy: :one_for_one)
        Supervisor.start_link([supervisor(ConsulNode.Supervisor, [])], strategy: :one_for_one)
      false ->
        Supervisor.start_link([supervisor(ConsulNode.Supervisor, [])], strategy: :one_for_one)
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConsulManager.Endpoint.config_change(changed, removed)
    :ok
  end
end
