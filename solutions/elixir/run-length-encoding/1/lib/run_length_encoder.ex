defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""

  def encode(string) do
    graphemes = string |> String.graphemes()

    if Enum.uniq(graphemes) == graphemes do
      string
    else
      graphemes
      |> Enum.chunk_by(& &1)
      |> Enum.map(&encode_chunk/1)
      |> Enum.join()
    end
  end

  defp encode_chunk([elem] = list) when length(list) == 1 do
    "#{elem}"
  end

  defp encode_chunk([head | tail]) do
    "#{length(tail) + 1}#{head}"
  end

  @spec decode(String.t()) :: String.t()
  def decode(""), do: ""

  def decode(string) do
    [_, number, char, tail] = Regex.run(~r/^([0-9]*)(.)(.*)/, string)

    if number == "" do
      char <> decode(tail)
    else
      {num, _} = Integer.parse(number)
      String.duplicate(char, num) <> decode(tail)
    end
  end
end
