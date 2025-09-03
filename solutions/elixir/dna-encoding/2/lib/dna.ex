defmodule DNA do
  def encode_nucleotide(code_point) do
    case code_point do
      ?\s -> 0
      ?A -> 1
      ?C -> 2
      ?G -> 4
      ?T -> 8
    end
  end

  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0 -> ?\s
      1 -> ?A
      2 -> ?C
      4 -> ?G
      8 -> ?T
    end
  end

  def encode(dna) do
    encode_helper(dna, <<>>)
  end

  defp encode_helper([], acc), do: acc

  defp encode_helper([head | tail], acc) do
    encoded = encode_nucleotide(head)
    encode_helper(tail, <<acc::bitstring, encoded::4>>)
  end

  def decode(dna) do
    decode_helper(dna, [])
  end

  defp decode_helper(<<>>, acc), do: reverse_list(acc)

  defp decode_helper(<<encoded::4, rest::bitstring>>, acc) do
    decoded = decode_nucleotide(encoded)
    decode_helper(rest, [decoded | acc])
  end

  defp reverse_list(list), do: reverse_helper(list, [])

  defp reverse_helper([], acc), do: acc

  defp reverse_helper([head | tail], acc) do
    reverse_helper(tail, [head | acc])
  end
end
