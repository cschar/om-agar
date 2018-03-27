defmodule Om.InfoSys.Supervisor do
use Supervisor
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    children = [

        # don't restart the counter
        worker(Om.InfoSys.WorkerCount, [3], restart: :temporary),
#        worker(Om.InfoSys.WorkerCount, [5])
        ]

  # get it in iex, when already started
  # {:error, {_, super_pid}} = Om.InfoSys.Supervisor.start_link
  # Supervisor.start_child(super_pid, [])

  ## or since we used name: __MODULE__ in start_link
  #  Supervisor.start_child(Om.InfoSys.Supervisor, [])

    supervise children, strategy: :simple_one_for_one
  end
end

