defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @regex ~r/\b[\w']+\b/

  @spec count(String.t()) :: map
  def count(sentence) do
    updated_sentence = update_sentence(sentence)

    @regex
    |> Regex.scan(updated_sentence)
    |> List.flatten()
    |> Enum.frequencies()
  end

  defp update_sentence(sentence) do
    sentence
    |> String.downcase()
    |> String.replace("_", " ")
  end
end
