defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance(~c"AAGTCATA", ~c"TAGCGATC")
  {:ok, 4}
  """

  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2), do: do_hamming(strand1, strand2, 0)

  defp do_hamming([], [], n), do: {:ok, n}
  defp do_hamming([a | tail1], [a | tail2], n), do: do_hamming(tail1, tail2, n)
  defp do_hamming([_a | tail1], [_b | tail2], n), do: do_hamming(tail1, tail2, n + 1)
  defp do_hamming(_strand1, _strand2, _), do: {:error, "strands must be of equal length"}
end
