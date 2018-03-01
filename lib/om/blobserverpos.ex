defmodule Om.Blobserverpos do
  use GenServer

  # API



  def start_link do
    # We now start the GenServer with a `name` option.

    GenServer.start_link(__MODULE__, %{}, name: :blobpos_room)
    IO.puts "== Genserver Blobserverpos started link"
  end


  def update_message(message) do
    GenServer.cast(:blobpos_room, {:update_message, message})
  end

  def remove_message_id(message_id) do
    GenServer.cast(:blobpos_room, {:remove_message_id, message_id})
  end

  def get_messages do
    GenServer.call(:blobpos_room, :get_messages)
  end


  # SERVER

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:remove_message_id, player_id}, player_pos_map) do
    new_map = Map.delete(player_pos_map, player_id)

    {:noreply, new_map}
  end

  def handle_cast({:update_message, pos}, pos_map) do

#  new_message = %{ player_id: 12, player_pos: %{ x: 12, y: 30}}


    {old_val, new_map } =
      Map.get_and_update(pos_map, pos[:player_id],
      fn current_value -> { current_value, pos[:player_pos]}
      end)

#    Blobserverpos.update_message(%{ player_id: :green2,
#                                    player_pos: %{ x: 12, y: 66}})


    {:noreply, new_map}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end
end
