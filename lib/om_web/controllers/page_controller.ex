defmodule OmWeb.PageController do
  use OmWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
