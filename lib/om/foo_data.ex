defmodule Om.FooData do
  import Plug.Conn
  import Ecto.Query, only: [from: 2]

  alias Om.{Repo, User}
  alias Om.Chatserver

  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end

  def foo_total(conn, _opts) do
    foo_total = Repo.one(from u in User, select: count("*"))
    assign(conn, :foo_total, foo_total)
  end

  def foo_email(conn, _opts) do
      emails = Repo.all(from u in User, select: %{u.id => u.email})
    assign(conn, :foo_email, inspect(emails) )
  end

  def foo_chatserver(conn, _opts) do
        msg = string_of_length(6)
        Chatserver.add_message(msg)
#        all_msgs = Chatserver.get_messages
        all_msgs = Enum.join(Chatserver.get_messages, "<br/>")
        assign(conn, :foo_chatserver, all_msgs)

  end

end