defmodule OmWeb.GridChannel do
#  use Phoenix.Channel
  use Phoenix.Channel, log_join: :info, log_handle_in: false


#  def terminate(_reason, socket) do
#    player_id = socket.assigns.current_user.id
#    Blobserverpos.remove_message_id(player_id)
#
#    IO.puts "agar_channel terminating , removed " <> inspect(player_id)
#  end

  ### topic:subtopic
  ## call elsehwere
  ##  OmWeb.Endpoint.broadcast(topic, event, msg)
  ##  --> OmWeb.Endpoint.broadcast("agar", "heartbeat", %{ msg: payload})


  def join("grid:lobby", _message, socket) do
    new_id = string_of_length(5)


    {:ok, %{ grid: [1,2,3]}, socket }
  end

  def join("grid:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    # could log the message into an analytics thing

    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
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



  def handle_out("heartbeat", payload, socket) do

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