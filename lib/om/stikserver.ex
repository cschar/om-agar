defmodule Om.Stikserver do
  use GenServer

  # API

  def start_link do
    # We now start the GenServer with a `name` option.

    GenServer.start_link(__MODULE__, %{}, name: :stick_room)
    IO.puts "== Genserver Stikserver started link"
  end

#  def add_message(pid, message) do
#    GenServer.cast(pid, {:add_message, message})
#  end

# And our function don't need to receive the pid anymore,
  # as we can reference the process with its unique name.
  def put(message) do
    GenServer.cast(:stick_room, {:put, message})
  end


  def get_all do
    GenServer.call(:stick_room, :get_all)
  end

  def remove(item) do
		GenServer.cast(:stick_room, {:remove, item})
	end


#  def get_messages(pid) do
#    GenServer.call(pid, :get_messages)
#  end

  # SERVER

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:put, new_message}, state) do
    {key, value} = new_message
    {:noreply, Map.put(state, key, value)}
  end


  def handle_cast({:remove, item}, state) do
		updated_map = Map.delete(state, item)
		{:noreply, updated_map}
	end

  def handle_call(:get_all, _from, state) do
    reply_to_sender = state
    pass_along_to_process = state
    {:reply, reply_to_sender, pass_along_to_process}
  end
end
