defmodule OmWeb.StikChannel do
#  use Phoenix.Channel
  use Phoenix.Channel, log_join: :info, log_handle_in: false
  # alias SimpleChat.ShoppingList
  alias Om.Blobserver
  alias Om.Blobserverpos



  def terminate(_reason, socket) do
    player_id = socket.assigns.current_user.id
    Blobserverpos.remove_message_id(player_id)

    IO.puts "agar_channel terminating , removed " <> inspect(player_id)
  end

  ### topic:subtopic
  ## call elsehwere
  ##  OmWeb.Endpoint.broadcast(topic, event, msg)
  ##  --> OmWeb.Endpoint.broadcast("agar", "heartbeat", %{ msg: payload})


  def join("agar:lobby", _message, socket) do
    new_id = string_of_length(5)


#    player_id = "user:#{socket.assigns.current_user.id} -- #{socket.assigns.current_user.name}"

    ## set in user_socket.ex Connect
    player_id = "#{socket.assigns.current_user.id}"
    new_blob_info = %{player_id: player_id,
                     player_pos: %{x: 200, y: 200}}

#    Blobserverpos.update_message(new_blob_info)

    {:ok, new_blob_info, socket }
  end

  def join("agar:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    # could log the message into an analytics thing
    IO.puts("agar input" <> body)
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end

  def handle_in("food_update", %{"body" => body}, socket) do

    if body["eaten"] != %{} do
      newly_eaten = body["eaten"]
      food_master = Blobserverpos.get_messages()[:food_master]
      food_spots = food_master[:spots]

      leftovers = Enum.filter(food_spots,
        fn(spot) ->  spot[:food_id] not in newly_eaten
        end)

#      leftovers = Enum.filter(food_spots,
#        fn {k,v} -> k not in newly_eaten end)


        update = %{ player_id: :food_master,
                    player_pos: %{ spots: leftovers}}
        Blobserverpos.update_message(update)
    end

#    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end


  def handle_in("new_pos", %{"body" => body}, socket) do

#    broadcast! socket, "heartbeat", body
#    broadcast! socket, "new_pos", body

    socket.assigns.current_user.id

    update = %{ player_id: socket.assigns.current_user.id,
                  player_pos: %{ x: body["pos_x"],
                                 y: body["pos_y"],
                                 r: body["radius"]}}
    Blobserverpos.update_message(update)

    {:noreply, socket}
  end

  def handle_out("new_pos", payload, socket) do

    IO.puts("handle out new pos" <> inspect(payload))

    heartbeat_body = Blobserverpos.get_messages()
    broadcast! socket, "heartbeat", %{body: heartbeat_body}

    {:noreply, socket}
  end


  def handle_out("heartbeat", payload, socket) do
    IO.puts("handle out heartbeat " <> inspect(payload))

    push socket, "heartbeat", payload
    {:noreply, socket}
  end



  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end
end