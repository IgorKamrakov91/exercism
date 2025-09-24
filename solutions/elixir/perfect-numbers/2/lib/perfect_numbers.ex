defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number < 1,
    do: {:error, "Classification is only possible for natural numbers."}

  def classify(number) do
    cond do
      deficient?(number) -> {:ok, :deficient}
      perfect?(number) -> {:ok, :perfect}
      abundant?(number) -> {:ok, :abundant}
    end
  end

  defp perfect?(number) do
    aliquot_sum(number) == number
  end

  defp abundant?(number) do
    aliquot_sum(number) > number
  end

  defp deficient?(number) do
    aliquot_sum(number) < number
  end

  defp aliquot_sum(1), do: 0

  defp aliquot_sum(number) do
    1..div(number, 2)
    |> Enum.filter(&(rem(number, &1) == 0))
    |> Enum.sum()
  end
end
