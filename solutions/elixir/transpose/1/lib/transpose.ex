defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    input
    |> String.split("\n")
    |> List.foldr([], &prepend_to_columns/2)
    |> Enum.join("\n")
  end

  defp prepend_to_columns(row_string, column_strings)
       when is_binary(row_string) and is_list(column_strings) do
    prepend_to_columns(String.graphemes(row_string), column_strings)
  end

  defp prepend_to_columns([], []), do: []

  defp prepend_to_columns([cell | cells], [column_string | column_strings]) do
    [cell <> column_string | prepend_to_columns(cells, column_strings)]
  end

  defp prepend_to_columns(cells_demanding_new_columns, []) do
    cells_demanding_new_columns
  end

  defp prepend_to_columns([], columns_needing_padding) do
    columns_needing_padding |> Enum.map(&(" " <> &1))
  end
end
