defmodule Om.ModoView do
  use Om.Web, :view

  def render("index.json", %{modos: modos}) do
    %{data: render_many(modos, Om.ModoView, "modo.json")}
  end

  def render("show.json", %{modo: modo}) do
    %{data: render_one(modo, Om.ModoView, "modo.json")}
  end

  def render("modo.json", %{modo: modo}) do
    %{id: modo.id,
      description: modo.description,
      complete: modo.complete}
  end
end
