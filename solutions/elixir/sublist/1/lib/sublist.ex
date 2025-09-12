defmodule Sublist do
  def compare(a, b) when a == b, do: :equal

  def compare(a, b) do
    cond do
      is_sublist?(a, b) -> :sublist
      is_sublist?(b, a) -> :superlist
      true -> :unequal
    end
  end

  defp is_sublist?([], _), do: true
  defp is_sublist?(a, b) when length(a) > length(b), do: false

  defp is_sublist?(a, b) do
    starts_with?(b, a) or is_sublist?(a, tl(b))
  end

  defp starts_with?(_, []), do: true
  defp starts_with?([], _), do: false
  defp starts_with?([h | t1], [h | t2]), do: starts_with?(t1, t2)
  defp starts_with?([_ | _], [_ | _]), do: false
end
