defmodule OmWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    # could log the message into an analytics thing


    if "gen" in String.split(body) do

      #abuse genservers and return results when done
      three_word_seq = Enum.map([:bob,:bib,:bub], fn(name) ->
        case Om.Wordserver.start_link(name) do
          {:ok, _} -> Om.Wordserver.send_for_words(name, 2)
            {:error, _} -> Om.Wordserver.send_for_words(name, 2)
        end


      end)

      IO.puts three_word_seq
      
      body = body <> inspect(three_word_seq)
    end

    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do


    push socket, "new_msg", payload
    {:noreply, socket}
  end

end