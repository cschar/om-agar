defmodule Metex.Worker do

## Metex.Worker.temperature_of "524901"
## via http://bulk.openweathermap.org/sample/city.list.json.gz

  def temperature_of(location) do
      result = url_for(location) |> HTTPoison.get |> parse_response

      case result do
                    {:ok, temp} ->
                     "#{location}: #{temp}°C"
                    :error ->
                     "#{location} not found"
      end
  end


  defp url_for(location) do
    #location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?id=#{location}&appid=#{apikey}"
  end

  defp parse_response(
         {:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
              body |> Poison.decode! |> compute_temperature
            end

  defp parse_response(_) do
              :error
  end


  defp compute_temperature(json) do
              try do
                temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
                {:ok, temp}
              rescue
                _ -> :error
              end
  end

  def apikey do
              System.get_env("OPEN_WEATHER_MAP_KEY")
  end
end
