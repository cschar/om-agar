defmodule Mix.Tasks.Readwords do
use Mix.Task


  def run(_args) do
    Mix.shell.info "Greetings from the Hello Phoenix Application!"
    readfile()
  end

    # Eager solution
        #if it already exists, increment it by 1

    # Efficient for small collections
    # inefficient for large collections w multiple passes

  defp readfile do
    File.read!("file.txt")
  |> String.split("\n")
  |> Enum.flat_map(&String.split/1)
  |> Enum.reduce( %{}, fn word, map ->
    Map.update(map, word, 1, & &1 + 1)
    end)
  end


    #lazy solution  (Stream)
    # less memory usage at the cost of computation
    # allow us to work with large or infinite collections

    defp readfilelazy do

    File.stream!("bigfile.txt", :line)
    |> Stream.flat_map(&String.split/1)
    |> Enum.reduce( %{}, fn word, map ->
    Map.update(map, word, 1, & &1 + 1)
    end)

    end

#lambda days notes
# FLOW lets us run this lazy code into something concurrent

# we give up ordering and process locality for concurrency

# but its not magic!
# overhead when data flows thru processes
# requires volume and/or cpu/io bound work
# to see benefits


# genstage
# --> a NEW behaviour
# allabout exchanging data between stages
# transparently w/ back-pressure
# 3 stages: producters, consumers and producer_Consumers

# its demand driven
# subscribe to a producer and DEMAND 10 items to consume

# DEMAND can be pushed through producder-consumer graph
# all the way to initial producers
# __it pushes back pressure to the boundary___




end