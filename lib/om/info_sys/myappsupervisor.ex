
defmodule Stack2 do
  use GenServer


  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def start_link(arg, id_str) do
    GenServer.start_link(__MODULE__, arg, name: :"stack_#{id_str}")
  end

  # Callbacks

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end
end

defmodule MyApp.Supervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link(arg) do
  IO.puts "MYAP []]]]]]]init info supervisor" <> inspect(arg)
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {Stack2, [:hello]}
    ]

    extra = for id <- 1..3 do
      worker(Stack2, [[id,3,2,90], id], id: id+10)
    end


    Supervisor.init(children ++ extra, strategy: :one_for_one)
    #Supervisor.init(children, strategy: :one_for_one)
  end
end