defmodule Om.PeriodicallyBlob do
  use GenServer

  alias Om.Blobserverpos

  def start_link do
    GenServer.start_link(__MODULE__, %{})

#          update = %{ player_id: :greenie2,
#                  player_pos: %{ x: 12, y: 66}}
#
#      Blobserverpos.update_message(update)


  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end


  def handle_info(:work, state) do
    # Do the work you desire here
#    IO.puts "Heartbeat"


#    greenie = %{ greenie: %{x: 130, y: 130}}
#      update = %{ player_id: :greenie,
#                  player_pos: %{ x: 12, y: 66}}

    gamedata = Blobserverpos.get_messages()
    greenie = gamedata[:greenie]
    new_x = Enum.random(-10..10)
    new_y = Enum.random(-10..10)

#    IO.puts(inspect(greenie))
#    IO.puts(inspect(Blobserverpos.get_messages()))
    new_blob_info = %{ player_id: :greenie,

      player_pos: %{
        x: greenie[:x] + new_x,
        y: greenie[:y] + new_y,
        r: greenie[:r] + Enum.random(-2..2)

    }}
#
    Blobserverpos.update_message(new_blob_info)



    food_spots = gamedata[:food_master][:spots]


    # Make Food condition
    if length(food_spots) < 200 do


      ids_in_use = food_spots |> Enum.map( fn k -> k[:food_id] end)
      
      # make 10 food each heartbeat
      num = Enum.take_random((1000..200000), 10)
      num = Enum.filter(num, fn x -> x not in ids_in_use end)

      new_food_spots = Enum.map(num, fn x ->
                      %{ food_id: x,
                         x: Enum.random(-1000..1000),
                         y: Enum.random(-1000..1000)
                      }
                    end)

      food_spots = new_food_spots ++ food_spots

      food_update = %{ player_id: :food_master,
                       player_pos: %{ spots: food_spots}}
      Blobserverpos.update_message(food_update)
    end

    heartbeat_msg = Blobserverpos.get_messages()
    OmWeb.Endpoint.broadcast("agar:lobby", "heartbeat", heartbeat_msg)


    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
#    Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # In 2 hours
#     Process.send_after(self(), :work, 2 * 1000) # 2 second
      Process.send_after(self(), :work, 1 * 1000) # 2 second
  end
end