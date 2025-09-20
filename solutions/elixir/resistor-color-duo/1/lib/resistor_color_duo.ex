defmodule ResistorColorDuo do
  @doc """
  Calculate a resistance value from two colors
  """

  @colors %{
    :black => "0",
    :brown => "1",
    :red => "2",
    :orange => "3",
    :yellow => "4",
    :green => "5",
    :blue => "6",
    :violet => "7",
    :grey => "8",
    :white => "9"
  }

  @spec value(colors :: [atom]) :: integer
  def value(colors) do
    colors
    |> Enum.take(2)
    |> Enum.map(&@colors[&1])
    |> Enum.join("")
    |> String.to_integer()
  end
end
