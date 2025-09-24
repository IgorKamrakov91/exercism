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
      is_deficient?(number) -> {:ok, :deficient}
      is_perfect?(number) -> {:ok, :perfect}
      is_abundant?(number) -> {:ok, :abundant}
    end
  end

  defp is_perfect?(number) do
    aliquot_sum(number) == number
  end

  defp is_abundant?(number) do
    aliquot_sum(number) > number
  end

  defp is_deficient?(number) do
    aliquot_sum(number) < number
  end

  defp aliquot_sum(1), do: 0

  defp aliquot_sum(number) do
    1..div(number, 2)
    |> Enum.filter(&(rem(number, &1) == 0))
    |> Enum.sum()
  end
end
