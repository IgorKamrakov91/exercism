defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map_join(" ", &translate_word/1)
  end

  @vowels ~w(a e i o u)

  defp translate_word(word) do
    word
    |> String.graphemes()
    |> pigify()
    |> Enum.join()
  end

  defp pigify([h | _] = word) when h in @vowels do
    word ++ ["ay"]
  end

  defp pigify(["q", "u" | tail]) do
    tail ++ ["quay"]
  end

  defp pigify(["y", second | _] = word) when second not in @vowels do
    word ++ ["ay"]
  end

  defp pigify(["x", second | _] = word) when second not in @vowels do
    word ++ ["ay"]
  end

  defp pigify([head | tail]) do
    pigify(tail ++ [head])
  end
end
