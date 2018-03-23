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
