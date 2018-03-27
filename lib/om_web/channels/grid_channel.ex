defmodule OmWeb.GridChannel do
#  use Phoenix.Channel
  use Phoenix.Channel, log_join: :error, log_handle_in: false


  def terminate(_reason, socket) do

  Om.PeriodicallyGrid.remove_player(
    socket.assigns.current_user.id)

    IO.puts "GRID_channel terminating , removed " <> inspect(socket.id)
  end
  ### topic:subtopic
  ## call elsehwere
  ##  OmWeb.Endpoint.broadcast(topic, event, msg)
  ##  --> OmWeb.Endpoint.broadcast("agar", "heartbeat", %{ msg: payload})


  def join("grid:lobby", _message, socket) do

    Om.PeriodicallyGrid.set_player(
    socket.assigns.current_user.id,
    socket.assigns.current_user.name,
    2)

    {:ok, %{ player_id: socket.assigns.current_user.id}, socket }
  end

  def join("grid:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_pos", %{"body" => body}, socket) do


    socket.assigns.current_user.id
    IO.inspect body


    Om.PeriodicallyGrid.set_player(
      socket.assigns.current_user.id,
      socket.assigns.current_user.name,
      body["grid_pos"])


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