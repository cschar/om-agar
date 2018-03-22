defmodule Pot do

  def simple do
    HTTPotion.get("https://httpbin.org/get", query: %{page: 2})
  end

end

Pot.simple