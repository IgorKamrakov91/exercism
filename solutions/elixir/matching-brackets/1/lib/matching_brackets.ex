defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """

  @brackets_pair ["()", "[]", "{}"]
  def check_brackets(string) do
    string
    |> String.replace(~r/[^{}()\[\]]/, "")
    |> match?()
  end

  defp match?(nil), do: false
  defp match?(""), do: true

  defp match?(string) do
    Enum.filter(@brackets_pair, fn pair -> String.contains?(string, pair) end)
    |> modify(string)
    |> match?()
  end

  defp modify([], _), do: nil

  defp modify(patterns, string) do
    Enum.reduce(patterns, string, fn pattern, string ->
      String.replace(string, pattern, "")
    end)
  end
end
