defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @letters ?a..?z

  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    atbash(plaintext) |> block_of_5()
  end

  defp block_of_5(text) do
    text |> Enum.chunk_every(5) |> Enum.join(" ")
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    atbash(cipher) |> to_string()
  end

  defp atbash(text) do
    String.downcase(text)
    |> String.to_charlist()
    |> Enum.filter(&alphanum?/1)
    |> Enum.map(&convert/1)
  end

  defp alphanum?(char) do
    char in @letters || char in ?0..?9
  end

  defp convert(char) when char in @letters do
    ?a + ?z - char
  end

  defp convert(char), do: char
end
