defmodule GoCounting do
  @type position :: {integer, integer}
  @type owner :: %{owner: atom, territory: [position]}
  @type territories :: %{white: [position], black: [position], none: [position]}

  @doc """
  Return the owner and territory around a position
  """
  @spec territory(board :: String.t(), position :: position) ::
          {:ok, owner} | {:error, String.t()}
  def territory(board_str, {x, y} = pos) do
    board = parse_board(board_str)
    width = board.width
    height = board.height

    if x < 0 or x >= width or y < 0 or y >= height do
      {:error, "Invalid coordinate"}
    else
      case Map.get(board.grid, pos) do
        :empty ->
          {territory, boundaries} = find_territory(board, pos)
          {:ok, %{owner: determine_owner(boundaries), territory: Enum.sort(territory)}}

        _ ->
          {:ok, %{owner: :none, territory: []}}
      end
    end
  end

  @doc """
  Return all white, black and neutral territories
  """
  @spec territories(board :: String.t()) :: territories
  def territories(board_str) do
    board = parse_board(board_str)

    all_empty =
      for x <- 0..(board.width - 1),
          y <- 0..(board.height - 1),
          Map.get(board.grid, {x, y}) == :empty,
          do: {x, y}

    find_all_territories(board, all_empty, %{white: [], black: [], none: []})
  end

  defp parse_board(board_str) do
    lines = String.split(board_str, "\n", trim: true)
    height = length(lines)
    width = if height > 0, do: String.length(Enum.at(lines, 0)), else: 0

    grid =
      for {line, y} <- Enum.with_index(lines),
          {char, x} <- Enum.with_index(String.to_charlist(line)),
          into: %{} do
        cell =
          case char do
            ?B -> :black
            ?W -> :white
            ?_ -> :empty
          end

        {{x, y}, cell}
      end

    %{grid: grid, width: width, height: height}
  end

  defp find_territory(board, start_pos) do
    bfs([start_pos], MapSet.new([start_pos]), MapSet.new(), board)
  end

  defp bfs([], visited, boundaries, _board) do
    {MapSet.to_list(visited), MapSet.to_list(boundaries)}
  end

  defp bfs([pos | queue], visited, boundaries, board) do
    {new_queue, new_visited, new_boundaries} =
      neighbors(pos, board)
      |> Enum.reduce({queue, visited, boundaries}, fn neighbor_pos, {q, v, b} ->
        case Map.get(board.grid, neighbor_pos) do
          :empty ->
            if MapSet.member?(v, neighbor_pos) do
              {q, v, b}
            else
              {q ++ [neighbor_pos], MapSet.put(v, neighbor_pos), b}
            end

          stone ->
            {q, v, MapSet.put(b, stone)}
        end
      end)

    bfs(new_queue, new_visited, new_boundaries, board)
  end

  defp neighbors({x, y}, board) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.filter(fn {nx, ny} ->
      nx >= 0 and nx < board.width and ny >= 0 and ny < board.height
    end)
  end

  defp determine_owner(boundaries) do
    case Enum.uniq(boundaries) do
      [:black] -> :black
      [:white] -> :white
      _ -> :none
    end
  end

  defp find_all_territories(_board, [], acc) do
    %{
      white: Enum.sort(acc.white),
      black: Enum.sort(acc.black),
      none: Enum.sort(acc.none)
    }
  end

  defp find_all_territories(board, [pos | rest], acc) do
    {territory, boundaries} = find_territory(board, pos)
    owner = determine_owner(boundaries)
    new_acc = Map.update!(acc, owner, &(&1 ++ territory))
    remaining_empty = rest -- territory
    find_all_territories(board, remaining_empty, new_acc)
  end
end
