defmodule Om.Chatserver do
  use GenServer

  # API

  def start_link do
    # We now start the GenServer with a `name` option.

    GenServer.start_link(__MODULE__, [], name: :chat_room)
    IO.puts "== Genserver started link"
  end

#  def add_message(pid, message) do
#    GenServer.cast(pid, {:add_message, message})
#  end

# And our function don't need to receive the pid anymore,
  # as we can reference the process with its unique name.
  def add_message(message) do
    GenServer.cast(:chat_room, {:add_message, message})
  end

  def get_messages do
    GenServer.call(:chat_room, :get_messages)
  end


#  def get_messages(pid) do
#    GenServer.call(pid, :get_messages)
#  end

  # SERVER

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, new_message}, messages) do
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end
end
