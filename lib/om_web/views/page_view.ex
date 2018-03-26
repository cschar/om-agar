defmodule OmWeb.PageView do
  use OmWeb, :view



  def render_existing("basic", _assigns) do
    "<p> test </p>"
  end

  def render("grid", assigns) do
    ~s{<script src="customjavascripts/grid.js"> </script>}
    |> raw
  end



end
