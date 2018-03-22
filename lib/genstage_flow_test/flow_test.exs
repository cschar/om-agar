defmodule Flowtest do
use Mix.Task

 def run(_args) do

 # Map-Reduce concurrently
  # roses are red ,\n violets are blue
  File.stream!("path/to/some/file")
  |> Flow.from_enumerable()
  |> Flow.flat_map(&String.split(&1, " "))


  # creates a new layer of stages with item keys grouped together
  |> Flow.partition()
  # "are" will be routed to the same 'stage'

  |> Flow.reduce(fn -> %{} end, fn word, acc ->
    Map.update(acc, word, 1, & &1 + 1)
  end)
  |> Enum.to_list()
  #|> Enum.into(%{})
end


end
