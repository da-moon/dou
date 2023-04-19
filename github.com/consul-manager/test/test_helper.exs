# start the current node as a manager
:ok = ConsulManager.start()

# start your application tree manually
Application.ensure_all_started(:consul_manager)

# run all tests!
ExUnit.start()
