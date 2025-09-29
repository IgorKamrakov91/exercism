defmodule Spiral do
  def matrix(0), do: []
  def matrix(n), do: matrix(1, n, n)
  defp matrix(_, _, 0), do: [[]]

  defp matrix(start, row, col),
    do: [
      Enum.to_list(start..(start + col - 1))
      | matrix(start + col, col, row - 1) |> Enum.reverse() |> Enum.zip_with(& &1)
    ]
end
