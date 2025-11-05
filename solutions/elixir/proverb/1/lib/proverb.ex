defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite([first | rest]) do
    recite_helper([first | rest]) <> "And all for the want of a #{first}.\n"
  end

  defp recite_helper(list) when length(list) <= 1, do: ""

  defp recite_helper([first | [second | rest]]) do
    "For want of a #{first} the #{second} was lost.\n" <> recite_helper([second | rest])
  end
end
