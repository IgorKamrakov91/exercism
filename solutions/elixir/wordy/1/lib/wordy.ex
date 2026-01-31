defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(question) do
    question
    |> String.replace_suffix("?", "")
    |> String.split()
    |> answer_inner
  end

  defp answer_inner(["What", "is", a | rest]) do
    answer_inner(String.to_integer(a), rest)
  end

  defp answer_inner(_), do: raise(ArgumentError)
  defp answer_inner(a, []), do: a

  defp answer_inner(a, ["plus", b | rest]) do
    answer_inner(a + String.to_integer(b), rest)
  end

  defp answer_inner(a, ["minus", b | rest]) do
    answer_inner(a - String.to_integer(b), rest)
  end

  defp answer_inner(a, ["divided", "by", b | rest]) do
    answer_inner(a / String.to_integer(b), rest)
  end

  defp answer_inner(a, ["multiplied", "by", b | rest]) do
    answer_inner(a * String.to_integer(b), rest)
  end

  defp answer_inner(_, _), do: raise(ArgumentError)
end
