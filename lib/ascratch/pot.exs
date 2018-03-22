defmodule Pot do
  alias HTTPotion

  def simple do
    HTTPotion.get("https://httpbin.org/get", query: %{page: 2})
  end

end

Pot.simple

# cd project_root
#iex -S mix lib/ascratch/pot.exs
# Pot.simple