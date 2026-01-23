defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str |> normalize() |> rectangle() |> group_by_column()
  end

  defp normalize(str) do
    str
    |> String.replace(~r/[[:punct:][:space:]]/, "")
    |> String.downcase()
  end

  defp rectangle(""), do: [[""]]

  defp rectangle(str) do
    column = str |> String.length() |> :math.sqrt() |> Float.ceil() |> Kernel.trunc()

    str |> String.codepoints() |> Enum.chunk_every(column, column, Stream.cycle([" "]))
  end

  defp group_by_column(strs) do
    strs |> Enum.zip() |> Enum.map_join(" ", &Tuple.to_list/1)
  end
end
