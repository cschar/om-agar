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
      # supervisor(Om.Blobserver, ["foo"])
      # Start your own worker by calling: Om.Worker.start_link(arg1, arg2, arg3)
      # worker(Om.Worker, [arg1, arg2, arg3]),

            worker(Om.Periodically, [])

    ]

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


    Om.Stikserver.start_link

    #50x50 grid --> 2500
#    grid_spot_num = :math.pow(15,2)
    grid_spot_num = 15*15
    grid_spots =
      (1..grid_spot_num) |>
        Enum.map(fn xy_pos ->

                 { xy_pos ,
                   %{current_object_id: -1,
                     food_level: Enum.random(1..10)}}end ) |>
        Map.new




    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
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
