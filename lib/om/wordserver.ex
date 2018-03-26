defmodule Om.Wordserver do
  use GenServer

  alias Om.Accounts
  alias Om.Accounts.Category
  alias Om.Repo
  # API

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
    #IO.puts "== Genserver Wordserver started link"
  end

  def send_for_words(pid, amount) do
      GenServer.call(pid, {:get_words, amount})
  end



  def handle_call({:get_words, amount}, _from, state) do

    top = Enum.random(1..4)
    reply = Enum.map( 1..top, fn x -> Repo.get(Category, x).name end)

    {:reply, reply, state}
  end
end
