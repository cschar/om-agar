defmodule Om.PeriodicallyGrid do
  use GenServer



  def start_link do

    gridspots =
      (1..20) |>
        Enum.map(fn x ->

                   %{id: -1,
                     infotype: OmWeb.AgarChannel.string_of_length(4),
                     food: Enum.random(1..10)} end)

      data = %{
        gridspots: gridspots,
        players: %{ bob: %{ name: "bob22", pos: 9 }}
        }

      GenServer.start_link(__MODULE__, data, name: :grid_room)
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end


  def set_player(player_id, player_name, player_pos) do
    GenServer.cast(:grid_room, {:set_player,
      %{id: player_id,
        data: %{name: player_name,
                pos: player_pos}}})
  end

  ### server

  def handle_cast({:set_player, player_info}, state) do

    new_players = Map.put(state[:players], player_info[:id],
                                         player_info[:data])
    state  = Map.put(state, :players, new_players)

    {:noreply, state}
  end


  def handle_info(:work, state) do



    OmWeb.Endpoint.broadcast("grid:lobby", "heartbeat",
      %{gridlist: Enum.take_random((1000..200000), 5),
        foo: 2,
        gridspots: state[:gridspots],
        gru_pos: Enum.random(1..10),
        players: state[:players]})

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
#    Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # In 2 hours
#     Process.send_after(self(), :work, 2 * 1000) # 2 second
      Process.send_after(self(), :work, 1 * 1000) # 2 second
  end
end