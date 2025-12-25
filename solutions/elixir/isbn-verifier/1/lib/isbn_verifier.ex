defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    isbn_cleaned = String.replace(isbn, "-", "")

    if valid_isbn_format?(isbn_cleaned) do
      calculate_checksum(isbn_cleaned) == 0
    else
      false
    end
  end

  defp valid_isbn_format?(isbn_cleaned) do
    String.match?(isbn_cleaned, ~r/^\d{9}[\dX]$/)
  end

  defp calculate_checksum(isbn_cleaned) do
    isbn_cleaned
    |> to_charlist()
    |> Enum.with_index()
    |> Enum.map(fn {char, index} -> isbn_int(char) * (10 - index) end)
    |> Enum.sum()
    |> Integer.mod(11)
  end

  defp isbn_int(c) when c in ?0..?9, do: c - ?0
  defp isbn_int(?X), do: 10
end
