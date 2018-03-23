defmodule A do
  use GenStage

  def start_link(number) do
    GenStage.start_link(A, number)
  end

  def init(counter) do
    {:producer, counter}
  end

  def handle_demand(demand, counter) when demand > 0 do
    # If the counter is 3 and we ask for 2 items, we will
    # emit the items 3 and 4, and set the state to 5.
    IO.puts "Genstage A: receiving demand " <> inspect(demand)
    IO.puts ("Generating items to consume...\n")
    Process.sleep(4000)

    events = Enum.map(counter..counter+demand-1,
      fn x ->
      inspect(x) <> " " <> inspect(demand)
#      Faker.Address.city <> inspect(demand)
    end)
#    receive do
#      {:process_item, item_num} ->
#        IO.puts("processing item" <> item_num)
#        events = events ++ [inspect(item_num) <> " ITEM"]
#
#    after
#      3_000 -> IO.puts("[][][]No external production heard, sending vanilla data")
#    end

#    events = Enum.to_list(counter..counter+demand-1)

    {:noreply, events, counter + demand}
  end
end



defmodule C do
  use GenStage

  def start_link() do
    GenStage.start_link(C, :ok)
  end

  def init(:ok) do
    {:consumer, :the_state_does_not_matter}
  end

  def handle_events(events, _from, state) do
    # Wait for a second.
    Process.sleep(1000)

    # Inspect the events.
    IO.puts("genstage C received events:" <> inspect(length(events)))
#    IO.inspect(events)
    IO.puts(inspect(events))

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end


defmodule TestGen do
  def t  do

  {:ok, a} = GenStage.start_link(A, 0)
  {:ok, c} = GenStage.start_link(C, :ok)
  GenStage.sync_subscribe(c,
    max_demand: 10, min_demand: 2,
    to: a)

  IO.puts("genstage test running")
#  Process.sleep(4000)
  Process.sleep(:infinity)


  end

  def t2  do

  {:ok, a} = GenStage.start_link(A, 0)


  IO.puts("T2 running")

  r = GenStage.call(a, 5)
  IO.puts inspect(r)
#  Process.sleep(4000)
  Process.sleep(:infinity)


  end
end

#TestGen.t

# start counting from zero
#{:ok, a} = GenStage.start_link(A, 0)
##{:ok, b} = GenStage.start_link(B, 2)   # expand by 2
#
# # state does not matter, so pass :ok as state into start_link
#{:ok, c} = GenStage.start_link(C, :ok)
#
#GenStage.sync_subscribe(c, to: a)
#
##GenStage.sync_subscribe(b, to: a)
##GenStage.sync_subscribe(c, to: b)
#
#IO.puts("genstage test running")
#Process.sleep(:infinity)
# wait 1 second
# 500 events
# wait 1 second
# 500 events....

# 500 IS DEFAULT ____min_demand______ in subscribe options
# 1000 is default MAX_demand

# max_demand and min_demand is used to keep both
# consumer and producers busy

# e.g. if min_demand is 5
# consumer gets 10
# consumer processes 5
# consumer asks for 5 MORE
# (while producer is generating those, consumer goes back to dealing
#  with current items)


defmodule Om.Gen.A do
  use GenStage

  def start_link(number) do
    GenStage.start_link(Om.Gen.A, number)
  end

  def init(counter) do
    {:producer, counter}
  end

  def handle_demand(demand, counter) when demand > 0 do
    # If the counter is 3 and we ask for 2 items, we will
    # emit the items 3 and 4, and set the state to 5.
    IO.puts "Genstage A: receiving demand " <> inspect(demand)
    IO.puts ("Generating items to consume...\n")
    Process.sleep(4000)

    events = Enum.map(counter..counter+demand-1,
      fn x ->
      inspect(x) <> " " <> inspect(demand)
#      Faker.Address.city <> inspect(demand)
    end)
#    receive do
#      {:process_item, item_num} ->
#        IO.puts("processing item" <> item_num)
#        events = events ++ [inspect(item_num) <> " ITEM"]
#
#    after
#      3_000 -> IO.puts("[][][]No external production heard, sending vanilla data")
#    end

#    events = Enum.to_list(counter..counter+demand-1)

    {:noreply, events, counter + demand}
  end
end

defmodule Om.Gen.C do
  use GenStage

  def start_link() do
    GenStage.start_link(Om.Gen.C, :ok)
  end

  def init(:ok) do
    {:consumer,
      :the_state_does_not_matter,
      subscribe_to: [{Om.Gen.A, max_demand: 10}]}
#      subscribe_to: [{B, options}]}
  end

  def handle_events(events, _from, state) do
    # Wait for a second.
    Process.sleep(1000)

    # Inspect the events.
    IO.puts("genstage C received events:" <> inspect(length(events)))
#    IO.inspect(events)
    IO.puts(inspect(events))

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end

