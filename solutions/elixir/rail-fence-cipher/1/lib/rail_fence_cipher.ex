defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str

  def encode(str, rails) do
    str
    |> String.graphemes()
    |> Enum.zip(rail_indices(rails))
    |> Enum.sort_by(fn {_, rail} -> rail end)
    |> Enum.map(fn {char, _} -> char end)
    |> Enum.join("")
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1), do: str

  def decode(str, rails) do
    len = String.length(str)

    indices =
      rail_indices(rails)
      |> Enum.take(len)
      |> Enum.with_index()
      |> Enum.sort_by(fn {rail, _} -> rail end)
      |> Enum.map(fn {_, original_idx} -> original_idx end)

    str
    |> String.graphemes()
    |> Enum.zip(indices)
    |> Enum.sort_by(fn {_, original_idx} -> original_idx end)
    |> Enum.map(fn {char, _} -> char end)
    |> Enum.join("")
  end

  defp rail_indices(rails) do
    period = 2 * (rails - 1)

    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(fn i ->
      rem = rem(i, period)
      if rem < rails, do: rem, else: period - rem
    end)
  end
end
