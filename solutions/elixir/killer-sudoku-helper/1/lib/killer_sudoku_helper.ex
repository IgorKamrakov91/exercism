defmodule KillerSudokuHelper do
  @numbers Enum.map(1..9, & &1)

  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{size: 1, sum: sum}), do: [[sum]]

  def combinations(cage) do
    (@numbers -- cage.exclude)
    |> Enum.map(&[&1])
    |> then(&do_combinations(&1, &1, cage.size))
    |> Enum.filter(&(count_eq_size?(&1, cage.size) and sum_eq_sum?(&1, cage.sum)))
  end

  defp do_combinations(_, acc, 1), do: acc

  defp do_combinations(numbers, acc, size) do
    new_acc =
      for x <- numbers,
          y <- acc,
          x < y,
          uniq: true,
          do: List.flatten([x, y]) |> Enum.dedup()

    do_combinations(numbers, new_acc, size - 1)
  end

  defp count_eq_size?(number, size) do
    Enum.count(number) == size
  end

  defp sum_eq_sum?(number, sum) do
    Enum.sum(number) == sum
  end
end
