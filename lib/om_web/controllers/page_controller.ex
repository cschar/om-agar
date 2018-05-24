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
  plug :authenticate_user  when action in [:blob, :grid]
#  plug Coherence.Authentication.Session, [protected: true] when action != :index


  def index(conn, _params) do
    render conn, "index.html", list: Chatserver.get_messages
  end



  def blob(conn, _params) do
    render conn, "blob.html"
  end



#
#  def render("scripts.html", _assigns) do
#    ~s{<script>require("web/static/js/posts").Post.run()</script>}
#    |> raw
#  end

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


  def sendjob(conn,  %{ "sendjobpost" => %{"floob" => floob}}) do
    name = String.to_atom(floob <> inspect(Enum.random(0..100)))

  #start up a task under our TaskSupervisor inside supervision tree
  Task.Supervisor.start_child(MyApp.TaskSupervisor, fn() ->
           Process.sleep 12000
           IO.puts("Task done from sendjob" <> inspect(name))
  end)

  Task.Supervisor.start_child(MyApp.TaskSupervisor, fn() ->
           Process.sleep 3000

           words = Om.Genius.homepage_words()
           IO.inspect words

           ## wont display since conn is already expired
           put_flash(conn, :info, ["job done: fetched words" <> inspect(words)] )

           attrs = %{title: "genius crawl",
                     description: Enum.join(words, " "),
                     url: "genius.com"}
          changeset =
            conn.assigns[:current_user]
            |> Ecto.build_assoc(:videos, attrs)

          Repo.insert(changeset)
  end)


    conn
  	|> put_flash(:info, ["Job sent w info:" <> inspect(floob)] )
	  |> redirect(to: page_path(conn, :index))
  end

end
