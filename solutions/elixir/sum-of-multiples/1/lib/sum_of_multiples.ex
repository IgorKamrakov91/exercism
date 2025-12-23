defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    1..(limit - 1)
    |> Enum.to_list()
    |> Enum.filter(fn number ->
      multiplies?(number, factors)
    end)
    |> Enum.sum()
  end

  defp multiplies?(number, factors) do
    factors
    |> Enum.filter(&(&1 != 0))
    |> Enum.any?(fn factor ->
      rem(number, factor) == 0
    end)
  end
end
