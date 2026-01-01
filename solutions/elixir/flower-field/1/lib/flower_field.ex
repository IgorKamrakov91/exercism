defmodule FlowerField do
  @doc """
  Annotate empty spots next to flowers with the number of flowers next to them.
  """

  @directions [
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1}
  ]

  @spec annotate([String.t()]) :: [String.t()]
  def annotate([]), do: []

  def annotate(board) do
    board
    |> Enum.with_index()
    |> Enum.map(&annotate_row(&1, board))
  end

  defp annotate_row({row, row_idx}, board) do
    row
    |> String.graphemes()
    |> Stream.with_index()
    |> Stream.map(fn {cell, col_idx} ->
      annotate_cell(board, cell, row_idx, col_idx)
    end)
    |> Enum.join()
  end

  defp annotate_cell(_board, "*", _row_idx, _col_idx), do: "*"

  defp annotate_cell(board, " ", row_idx, col_idx) do
    board
    |> count_adjacent_flowers(row_idx, col_idx)
    |> case do
      0 -> " "
      count -> Integer.to_string(count)
    end
  end

  defp count_adjacent_flowers(board, row_idx, col_idx) do
    @directions
    |> Stream.map(fn {row_delta, col_delta} ->
      {row_idx + row_delta, col_idx + col_delta}
    end)
    |> Enum.count(&flower?(board, &1))
  end

  defp flower?(board, {row_idx, col_idx}) when row_idx >= 0 and col_idx >= 0 do
    with {:ok, row} <- Enum.fetch(board, row_idx),
         {:ok, cell} <- row |> String.graphemes() |> Enum.fetch(col_idx) do
      cell == "*"
    else
      _ -> false
    end
  end

  defp flower?(_board, _position), do: false
end
