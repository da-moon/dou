# consul-manager

    mix deps.get
  
    [PORT=400X] iex --name foo@172.20.20.11 --cookie chocolate -S mix phx.server

  Connect manual
  
    Node.ping :"bar@172.20.20.21" or Node.connect "bar@172.20.20.21"
    
    Node.list


  If you are using this locally, you need to comment in lib/consul_manager.ex 

    multicast_addr: m_addr, line

  Then run master node with

    iex --sname foo --cookie chocolate -S mix phx.server

  and other with

    [PORT=400X] iex --sname bar --cookie chocolate -S mix phx.server
