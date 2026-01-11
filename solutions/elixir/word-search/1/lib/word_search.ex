defmodule WordSearch do
  defmodule Location do
    defstruct [:from, :to]

    @type t :: %Location{
            from: %{row: integer, column: integer},
            to: %{row: integer, column: integer}
          }
  end

  @doc """
  Find the start and end positions of words in a grid of letters.
  Row and column positions are 1 indexed.
  """
  @spec search(grid :: String.t(), words :: [String.t()]) :: %{String.t() => nil | Location.t()}
  def search(grid, words) do
    parsed_grid = parse_grid(grid)

    words |> Enum.map(fn word -> {word, find_word(parsed_grid, word)} end) |> Map.new()
  end

  defp parse_grid(grid) do
    grid |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)
  end

  defp find_word(grid, word) do
    rows = length(grid)
    cols = if rows > 0, do: length(Enum.at(grid, 0)), else: 0

    for row <- 0..(rows - 1), col <- 0..(cols - 1), direction <- directions() do
      search_from_position(grid, word, row, col, direction)
    end
    |> Enum.find(&(&1 != nil))
  end

  defp directions do
    [
      # right
      {0, 1},
      # left
      {0, -1},
      # down
      {1, 0},
      # up
      {-1, 0},
      # down-right
      {1, 1},
      # down-left
      {1, -1},
      # up-right
      {-1, 1},
      # up-left
      {-1, -1}
    ]
  end

  defp search_from_position(grid, word, row, col, {dr, dc}) do
    chars = String.graphemes(word)

    if matches_at_position?(grid, chars, row, col, dr, dc) do
      end_row = row + dr * (length(chars) - 1)
      end_col = col + dc * (length(chars) - 1)

      %Location{
        from: %{row: row + 1, column: col + 1},
        to: %{row: end_row + 1, column: end_col + 1}
      }
    else
      nil
    end
  end

  defp matches_at_position?(grid, chars, row, col, dr, dc) do
    chars
    |> Enum.with_index()
    |> Enum.all?(fn {char, i} ->
      current_row = row + dr * i
      current_col = col + dc * i

      valid_position?(grid, current_row, current_col) and
        get_char(grid, current_row, current_col) == char
    end)
  end

  defp valid_position?(grid, row, col) do
    row >= 0 and row < length(grid) and col >= 0 and col < length(Enum.at(grid, row, []))
  end

  defp get_char(grid, row, col) do
    grid |> Enum.at(row, []) |> Enum.at(col)
  end
end
