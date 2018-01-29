defmodule Om.FooData do
  import Plug.Conn

  def foo_total(conn, _opts) do
    assign(conn, :foo_total, 3)
  end
end