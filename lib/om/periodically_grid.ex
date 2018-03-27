defmodule Om.PeriodicallyGrid do
  use GenServer

  @size 20

  def start_link do

    gridspots =
      (1..@size) |>
        Enum.map(fn x ->

                   %{id: -1,
                     infotype: OmWeb.AgarChannel.string_of_length(4),
                     food: Enum.random(1..10)} end)

      data = %{
        gridspots: gridspots,
        players: %{ bob: %{ name: "bob22", pos: 9 }},
        gru: %{ pos: Enum.random(1..10), hp: 100}
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

  def remove_player(player_id) do
    GenServer.cast(:grid_room, {:remove_player, player_id})
  end

  ### server

  def handle_cast({:set_player, player_info}, state) do

    new_players = Map.put(state[:players], player_info[:id],
                                         player_info[:data])
    state  = Map.put(state, :players, new_players)

    {:noreply, state}
  end

  def handle_cast({:remove_player, player_id}, state) do

    new_players = Map.delete(state[:players], player_id)
    state  = Map.put(state, :players, new_players)
    {:noreply, state}
  end


  def handle_info(:work, state) do
  #state = %{ players: %{ bob: %{ name: :bobby, pos: 9}, tom: %{ name: :tommy, pos: 1}}, gru: %{ pos: 9}}

    gru_move_chance =
      Enum.reduce(state[:players], 0, fn({player_id, info}, acc) ->
#        IO.puts player_id
#        IO.inspect info
#        IO.inspect state[:gru][:pos]

        case info[:pos] == state[:gru][:pos] do
          true -> acc + 2
          false -> acc
        end

      end)

    IO.puts gru_move_chance

    stay_put_chance = Enum.random(1..10)

    if gru_move_chance > stay_put_chance do
#
      new_pos = rem(state[:gru][:pos] + Enum.random(1..10), @size)
      new_gru = Map.put(state[:gru], :pos, new_pos)
#
      state  = Map.put(state, :gru, new_gru)
#
      msg = "players persuaded gru to move @ " <>  inspect(new_pos)
      OmWeb.Endpoint.broadcast!("room:lobby", "new_msg", %{body: msg}    )
    end


    OmWeb.Endpoint.broadcast("grid:lobby", "heartbeat",
      %{gridlist: Enum.take_random((1000..200000), 5),
        foo: 2,
        gridspots: state[:gridspots],
        gru: state[:gru],
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