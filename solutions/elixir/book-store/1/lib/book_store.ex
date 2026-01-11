defmodule BookStore do
  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5

  @prices %{
    1 => 800 * 1 * 1.00,
    2 => 800 * 2 * 0.95,
    3 => 800 * 3 * 0.90,
    4 => 800 * 4 * 0.80,
    5 => 800 * 5 * 0.75
  }

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.
  """
  @spec total(basket :: [book]) :: integer
  def total(basket) do
    Enum.frequencies(basket) |> group() |> Enum.map(&cost/1) |> Enum.sum()
  end

  defp group(books, result \\ [])

  defp group(books, result) when map_size(books) == 0 do
    if 3 not in result or 5 not in result do
      result
    else
      group(books, (result -- [3, 5]) ++ [4, 4])
    end
  end

  defp group(books, result) do
    data =
      Enum.reject(books, fn {_, n} -> n == 0 end)
      |> Enum.map(fn {k, v} -> {k, v - 1} end)

    group(Map.new(data), [length(data) | result])
  end

  defp cost(s_no), do: Map.get(@prices, s_no, 0) |> trunc()
end
