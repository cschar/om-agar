defmodule Om.Periodically do
  use GenServer

  alias Om.Blobserver
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


    greenie = Blobserverpos.get_messages()[:greenie]
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

#    OmWeb.Endpoint.broadcast()
#    OmWeb.Endpoint.broadcast("agar", "heartbeat", %{ msg: "bah"})


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