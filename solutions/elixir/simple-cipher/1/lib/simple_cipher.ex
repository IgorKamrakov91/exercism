defmodule SimpleCipher do
  @alphabet_size 26
  @first_letter ?a

  @spec encode(String.t(), String.t()) :: String.t()
  def encode(plaintext, key) do
    transform(plaintext, key, fn text_idx, key_idx ->
      text_idx + key_idx
    end)
  end

  @spec decode(String.t(), String.t()) :: String.t()
  def decode(ciphertext, key) do
    transform(ciphertext, key, fn text_idx, key_idx ->
      text_idx - key_idx + @alphabet_size
    end)
  end

  def generate_key(length) do
    1..length
    |> Enum.map(fn _ -> gen_random_letter() end)
    |> Enum.join()
  end

  defp gen_random_letter do
    index = :rand.uniform(@alphabet_size) - 1
    <<@first_letter + index>>
  end

  defp transform(text, key, combine_fun) do
    text_chars = String.to_charlist(text)
    key_chars = String.to_charlist(key)

    text_length = length(text_chars)

    full_key_chars =
      key_chars
      |> Stream.cycle()
      |> Enum.take(text_length)

    text_chars
    |> Enum.zip(full_key_chars)
    |> Enum.map(fn {text_ch, key_ch} ->
      transform_char(text_ch, key_ch, combine_fun)
    end)
    |> to_string()
  end

  defp transform_char(text_ch, key_ch, combine_fun) do
    text_idx = text_ch - @first_letter
    key_idx = key_ch - @first_letter

    result_idx = combine_fun.(text_idx, key_idx)
    wrapped_idx = rem(result_idx, @alphabet_size)

    <<@first_letter + wrapped_idx>>
  end
end
