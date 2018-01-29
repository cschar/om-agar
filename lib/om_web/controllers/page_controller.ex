defmodule OmWeb.PageController do
  use OmWeb, :controller

  import Om.FooData
  alias Om.Chatserver

  plug :foo_total
  plug :foo_email
  plug :foo_chatserver

  def index(conn, _params) do
    render conn, "index.html", list: Chatserver.get_messages
  end

end
