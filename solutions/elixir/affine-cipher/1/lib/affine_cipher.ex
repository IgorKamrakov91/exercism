defmodule AffineCipher do
  import Enum
  import Integer, except: [to_charlist: 1]

  @m ?z - ?a + 1
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    case gcd(a, @m) do
      1 -> {:ok, encode(message, a, b)}
      _ -> {:error, "a and m must be coprime."}
    end
  end

  defp encode(message, a, b) do
    message |> String.downcase() |> to_charlist() |> flat_map(&encode_char(&1, a, b)) |> format()
  end

  defp encode_char(char, a, b) when char in ?a..?z do
    [mod(a * (char - ?a) + b, @m) + ?a]
  end

  defp encode_char(char, _, _) when char in ?0..?9, do: [char]
  defp encode_char(_, _, _), do: []

  defp format(encoded) do
    encoded |> chunk_every(5) |> map(&List.to_string/1) |> join(" ")
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), encrypted :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    case extended_gcd(a, @m) do
      {1, m, _} -> {:ok, decode(encrypted, b, m)}
      {_, _, _} -> {:error, "a and m must be coprime."}
    end
  end

  defp decode(encrypted, b, m) do
    mmi = mod(m, @m)
    encrypted |> to_charlist() |> flat_map(&decode_char(&1, b, mmi)) |> List.to_string()
  end

  defp decode_char(char, b, mmi) when char in ?a..?z, do: [mod(mmi * (char - ?a - b), @m) + ?a]
  defp decode_char(char, _, _) when char in ?0..?9, do: [char]
  defp decode_char(_, _, _), do: []
end
