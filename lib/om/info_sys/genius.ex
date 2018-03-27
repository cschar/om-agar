defmodule Om.Genius do



  def homepage_words() do
      result = "https://genius.com"
               |> HTTPoison.get
               |> parse_response
  end


#  def lyrics_for(key_words) do
#      result = url_for(key_words) |> HTTPoison.get |> parse_response
#  end


#  defp url_for(query) do
#    url_string = String.split(query) |> Enum.join("%20")
#    "https://genius.com/search?q=#{url_string}"
#  end

  defp parse_response(
         {:ok, %HTTPoison.Response{body: body, status_code: 200}}) do

      body
      |> Floki.find("div .home_featured_latest_story-title")
      |> Enum.reduce( [], fn ({_,_,text}, acc) -> acc ++ text end)
      |> Enum.join(" ")
      |> String.split(" ")
      |> Enum.take_random(5)

  end

  defp parse_response(_) do
              :error
  end

end