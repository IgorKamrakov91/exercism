defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    string = sentence |> String.downcase() |> String.replace(~r/[^a-z]/, "")

    length =
      string
      |> String.graphemes()
      |> Enum.uniq()
      |> Enum.count()

    length == String.length(string)
  end
end
