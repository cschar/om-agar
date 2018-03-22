defmodule Pot2 do

  def simple2 do
    HTTPotion.get("https://httpbin.org/get", query: %{page: 2})
  end

end
