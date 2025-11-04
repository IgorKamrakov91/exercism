defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    cond do
      winner?(board, "X", :left_right) -> :black
      winner?(board, "O", :top_bottom) -> :white
      true -> :none
    end
  end

  defp winner?(board, player, direction) do
    height = length(board)
    width = if height > 0, do: String.length(hd(board)), else: 0

    start_positions =
      case direction do
        :left_right -> for row <- 0..(height - 1), do: {row, 0}
        :top_bottom -> for col <- 0..(width - 1), do: {0, col}
      end

    Enum.any?(start_positions, fn pos ->
      at(board, pos) == player and connected?(board, player, pos, direction, MapSet.new())
    end)
  end

  defp connected?(board, player, {row, col}, direction, visited) do
    height = length(board)
    width = if height > 0, do: String.length(hd(board)), else: 0

    reached_goal =
      case direction do
        :left_right -> col == width - 1
        :top_bottom -> row == height - 1
      end

    if reached_goal do
      true
    else
      visited = MapSet.put(visited, {row, col})

      neighbors({row, col})
      |> Enum.filter(fn pos -> at(board, pos) == player and not MapSet.member?(visited, pos) end)
      |> Enum.any?(fn pos -> connected?(board, player, pos, direction, visited) end)
    end
  end

  defp neighbors({row, col}) do
    [
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col}
    ]
  end

  defp at(board, {row, col}) do
    if row >= 0 and row < length(board) do
      row_string = Enum.at(board, row)

      if col >= 0 and col < String.length(row_string) do
        String.at(row_string, col)
      end
    end
  end
end
