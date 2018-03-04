defmodule OmWeb.PageController do
  use OmWeb, :controller

  import Om.FooData
  alias Om.Chatserver
  alias Om.{Repo, User}

  plug :foo_total
  plug :foo_email
  plug :foo_chatserver

  ## custom plug set in router, defined in controllers/auth.ex
  import Om.Auth
  plug :authenticate_user  when action in [:blob]
#  plug Coherence.Authentication.Session, [protected: true] when action != :index


  def index(conn, _params) do
    render conn, "index.html", list: Chatserver.get_messages
  end

  def blob(conn, _params) do
    render conn, "blob.html"
  end

  def create(conn, %{ "page" => %{"username" => username}}) do
    changeset = User.changeset(%User{},
      %{name: username})


    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Om.Auth.login(user)
        |> redirect(to: page_path(conn, :blob))
      {:error, changeset} ->
        conn
        |> put_flash(:info, ["Error", inspect(changeset)] )
        |> render("index.html")
    end
  end

  def logout(conn, _params) do
  	conn
  	|> Om.Auth.logout()
	  |> redirect(to: page_path(conn, :index))
  end

end
