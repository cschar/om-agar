defmodule OmWeb.VideoController do
  use OmWeb, :controller

  alias Om.Accounts
  alias Om.Accounts.Video

  alias Om.Repo

  ## custom plug set in router, defined in controllers/auth.ex
 # import Om.Auth
 # plug :authenticate_user  when action in [:new, :create, :edit, :update, :delete]
#  plug Coherence.Authentication.Session, [protected: true] when action != :index

  #APPLIED at end of plug pipeline
  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
    [conn, conn.params, conn.assigns.current_user])

  # will give  ane xtra param on controllers now
  # conn.assigns.current_user
end

  def index(conn, _params, user) do
    videos = Accounts.list_videos()

    #user_w_videos = Repo.preload(user, :videos)
    #current_user_videos = user_w_videos.videos

    current_user_videos = Repo.all(user_videos(user))

    render(conn, "index.html",
      videos: videos,
      current_user_videos: current_user_videos )
      #current_user_videos: [])
  end

  defp user_videos(user) do
      Ecto.assoc(user, :videos) # builds an Ecto.Query
  end

  def new(conn, _params, user) do
    vid = %Video{user_id: user.id, title: "hi", description: "says hi", url: "example.com"}
    changeset = Accounts.change_video(vid)

#    changeset =
#      conn.assigns.current_user
#      |> Ecto.assoc(:videos)
#      |> Video.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
#    case Accounts.create_video(video_params) do
#      {:ok, video} ->
#        conn
#        |> put_flash(:info, "Video created successfully.")
#        |> redirect(to: video_path(conn, :show, video))
#      {:error, %Ecto.Changeset{} = changeset} ->
#        render(conn, "new.html", changeset: changeset)
#    end

    changeset =
      user
      |> Ecto.build_assoc(:videos)
      |> Video.changeset(video_params)


    case Repo.insert(changeset) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = Accounts.get_video!(id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Accounts.get_video!(id)
    changeset = Accounts.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Accounts.get_video!(id)

    case Accounts.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = Accounts.get_video!(id)
    {:ok, _video} = Accounts.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end
end
