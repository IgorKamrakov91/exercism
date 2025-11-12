defmodule GameOfLife do
  @doc """
  Apply the rules of Conway's Game of Life to a grid of cells
  """

  @spec tick(matrix :: list(list(0 | 1))) :: list(list(0 | 1))
  def tick([]), do: []

  def tick(matrix) do
    matrix
    |> sum_vertical()
    |> sum_horizontal()
    |> Enum.zip_with(
      matrix,
      &Enum.zip_with(&1, &2, fn a, b -> alive(a, b) end)
    )
  end

  def sum_vertical(matrix) do
    [hd(matrix) |> Enum.map(fn _ -> 0 end) | matrix]
    |> Enum.chunk_every(3, 1)
    |> Enum.map(fn chunk ->
      Enum.zip_with(chunk, &Enum.sum/1)
    end)
  end

  defp sum_horizontal(matrix) do
    for row <- matrix do
      [0 | row]
      |> Enum.chunk_every(3, 1)
      |> Enum.map(&Enum.sum/1)
    end
  end

  defp alive(3, _), do: 1
  defp alive(4, 1), do: 1
  defp alive(_, _), do: 0
end
