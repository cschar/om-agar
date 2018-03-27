defmodule Om.Application do
  use Application

  alias Om.Chatserver
  alias Om.Blobserverpos

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Om.Repo, []),
      # Start the endpoint when the application starts
      supervisor(OmWeb.Endpoint, []),

      #Task.Supervisor.start_child(MyApp.TaskSupervisor, fn() -> Process.sleep 3000
      {Task.Supervisor, name: MyApp.TaskSupervisor},
      {MyApp.Supervisor, name: Toma},
#      supervisor(Task.Supervisor, name: MyApp.TaskSupervisor),
      supervisor(Om.InfoSys.Supervisor, [], name: :count),


      worker(Om.PeriodicallyBlob, [], name: :Pero),
      worker(Om.PeriodicallyGrid, [])

    ]

#    Faker.start


    #:observer.start

    ### trying to use genserver...
    Chatserver.start_link
    Chatserver.add_message("foo")
    Om.Blobserver.start_link
    Om.Blobserver.add_message("user0")


    Blobserverpos.start_link()
    update = %{ player_id: :greenie,
                  player_pos: %{ x: 120, y: 120, r: 45}}
    Blobserverpos.update_message(update)

    food_spots = Blobserverpos.gen_food_spots()
    update = %{ player_id: :food_master,
                player_pos: %{ spots: food_spots}}
    Blobserverpos.update_message(update)




    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    ## :one_for_one  , if one terminates, restart that one

    ## :one_for_all, if one terminates, restart ALL of them

    ## :rest_for_one,  only restart procs below one that terminated
#      worker(worker0, [])  # wont restart
#      worker(worker1, [])  # terminated
#      worker(worker2, [])  # will restart
#      worker(worker3, [])  # will restart
#
    ## :simple_one_for_one,
    # only allows ONE type of worker to be defined
    # when started, gives an EMPTY list of children
    # even though we defined 1...

    ## wel have to manually start it
    ## Supervisor.start_child(super_pid, [])
    ## note we dont specify anything about worker process

    ## to shutdown a worker
    #  Supervisor.terminate_child(super_pid, worker_pid)

              # for child processes of same type
              # TODO: try adding for each user that is logged on
              
    opts = [strategy: :one_for_one, name: Om.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OmWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
