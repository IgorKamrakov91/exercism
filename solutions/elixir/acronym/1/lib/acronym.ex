defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    String.split(string, ~r/\s|-|_/)
    |> Enum.map(&String.upcase/1)
    |> Enum.map(fn word -> String.first(word) end)
    |> Enum.join("")
  end
end
