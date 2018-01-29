defmodule Om.ModoController do
  use Om.Web, :controller

  alias Om.Modo

  def index(conn, _params) do
    modos = Repo.all(Modo)
    render(conn, "index.json", modos: modos)
  end

  def create(conn, %{"modo" => modo_params}) do
    changeset = Modo.changeset(%Modo{}, modo_params)

    case Repo.insert(changeset) do
      {:ok, modo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", modo_path(conn, :show, modo))
        |> render("show.json", modo: modo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Om.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    modo = Repo.get!(Modo, id)
    render(conn, "show.json", modo: modo)
  end

  def update(conn, %{"id" => id, "modo" => modo_params}) do
    modo = Repo.get!(Modo, id)
    changeset = Modo.changeset(modo, modo_params)

    case Repo.update(changeset) do
      {:ok, modo} ->
        render(conn, "show.json", modo: modo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Om.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    modo = Repo.get!(Modo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(modo)

    send_resp(conn, :no_content, "")
  end
end
