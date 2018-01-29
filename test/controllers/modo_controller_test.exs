defmodule Om.ModoControllerTest do
  use Om.ConnCase

  alias Om.Modo
  @valid_attrs %{complete: true, description: "some description"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, modo_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    modo = Repo.insert! %Modo{}
    conn = get conn, modo_path(conn, :show, modo)
    assert json_response(conn, 200)["data"] == %{"id" => modo.id,
      "description" => modo.description,
      "complete" => modo.complete}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, modo_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, modo_path(conn, :create), modo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Modo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, modo_path(conn, :create), modo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    modo = Repo.insert! %Modo{}
    conn = put conn, modo_path(conn, :update, modo), modo: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Modo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    modo = Repo.insert! %Modo{}
    conn = put conn, modo_path(conn, :update, modo), modo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    modo = Repo.insert! %Modo{}
    conn = delete conn, modo_path(conn, :delete, modo)
    assert response(conn, 204)
    refute Repo.get(Modo, modo.id)
  end
end
