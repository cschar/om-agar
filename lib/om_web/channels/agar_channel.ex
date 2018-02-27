defmodule OmWeb.AgarChannel do
  use Phoenix.Channel
  # alias SimpleChat.ShoppingList
  alias Om.Blobserver
  alias Om.Blobserverpos


  def terminate(_reason, socket) do
    IO.puts "terminating"
  end

  ### topic:subtopic
  ## call elsehwere
  ##  OmWeb.Endpoint.broadcast(topic, event, msg)
  ##  --> OmWeb.Endpoint.broadcast("agar", "heartbeat", %{ msg: payload})


  def join("agar:lobby", _message, socket) do
    new_id = string_of_length(5)    

    IO.puts "New blob joined " <> new_id
#    Om.Blobserver.add_message(new_id)
    IO.puts "Current blobs in game: " <> Enum.join(Blobserver.get_messages, " ")

    new_blob_info = %{player_id: new_id,
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


  def handle_in("new_pos", %{"body" => body}, socket) do

    IO.puts("new pos" <> inspect(body))
#    broadcast! socket, "heartbeat", body
    broadcast! socket, "new_pos", body
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