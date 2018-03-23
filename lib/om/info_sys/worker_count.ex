defmodule Om.InfoSys.WorkerCount do
  use GenServer

  def start_link(initial_value) do
    IO.puts ("strart link counter")
    GenServer.start_link(__MODULE__, initial_value)
  end

  def init(initial_val) do
    Process.send_after self(), :tick, 500  #start ticking
    {:ok, initial_val}
  end


  def handle_info(:tick, val) when val <= 0, do: raise "boom!"
  def handle_info(:tick, val) do
    IO.puts "Tick" <> inspect(val)
    Process.send_after(self(), :tick, 1 * 1000) # 2 second
    {:noreply, val-1}
  end


end