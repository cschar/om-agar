defmodule Om.InfoSys.Supervisor do
use Supervisor
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    children = [

        # don't restart the counter
       # worker(Om.InfoSys.Worker2, [3], restart: :temporary),
        worker(Om.InfoSys.WorkerCount, [20], id: :h)
        ]

    #opts = [strategy: :one_for_one, name: Om.InfoSys.Supervisor]
    #Supervisor.start_link(children, opts)
    IO.puts "init info supervisor"
    supervise children, strategy: :simple_one_for_one
  end
end

#
#:permanent
#The child is always restarted (default).
#:temporary
#The child is never restarted.
#:transient
#The child is restarted only if it terminates abnormally, with an exit reason
#other than :normal, :shutdown, or {:shutdown, term}.

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