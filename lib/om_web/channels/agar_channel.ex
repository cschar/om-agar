defmodule OmWeb.AgarChannel do
  use Phoenix.Channel
  # alias SimpleChat.ShoppingList
  alias Om.Blobserver

  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end

  def join("agar:lobby", _message, socket) do
    new_id = string_of_length(5)    

    IO.puts "New blob joined " <> new_id
    Om.Blobserver.add_message(new_id)
    IO.puts "Current blobs in game: " <> Enum.join(Blobserver.get_messages, " ")

    {:ok, %{player_id: new_id}, socket }
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

end