defmodule JigsawPuzzle do
  @doc """
  Fill in missing jigsaw puzzle details from partial data
  """

  @type format() :: :landscape | :portrait | :square
  @type t() :: %__MODULE__{
          pieces: pos_integer() | nil,
          rows: pos_integer() | nil,
          columns: pos_integer() | nil,
          format: format() | nil,
          aspect_ratio: float() | nil,
          border: pos_integer() | nil,
          inside: pos_integer() | nil
        }

  defstruct [:pieces, :rows, :columns, :format, :aspect_ratio, :border, :inside]

  @spec data(jigsaw_puzzle :: JigsawPuzzle.t()) ::
          {:ok, JigsawPuzzle.t()} | {:error, String.t()}
  def data(jigsaw_puzzle) do
    case solve_puzzle(jigsaw_puzzle) do
      {:ok, result} -> {:ok, result}
      {:error, "Contradictory data"} -> {:error, "Contradictory data"}
      {:error, _} -> {:error, "Insufficient data"}
    end
  end

  defp solve_puzzle(jigsaw_puzzle) do
    with {:ok, :no_error} <- check_contradictions(jigsaw_puzzle),
         {:ok, puzzle} <- iterative_solve(jigsaw_puzzle) do
      {:ok, puzzle}
    else
      error -> error
    end
  end

  defp check_contradictions(%{format: :square, rows: rows, columns: cols})
       when rows != nil and cols != nil and rows != cols do
    {:error, "Contradictory data"}
  end

  defp check_contradictions(_), do: {:ok, :no_error}

  defp iterative_solve(puzzle) do
    solve_iterations(puzzle, 10)
  end

  defp solve_iterations(_puzzle, 0), do: {:error, "Insufficient data"}

  defp solve_iterations(puzzle, depth) do
    new_puzzle = %JigsawPuzzle{
      pieces: safe_get_pieces(puzzle),
      rows: safe_get_rows(puzzle),
      columns: safe_get_columns(puzzle),
      format: safe_get_format(puzzle),
      aspect_ratio: safe_get_aspect_ratio(puzzle),
      border: safe_get_border(puzzle),
      inside: safe_get_inside(puzzle)
    }

    if puzzle_complete?(new_puzzle) do
      {:ok, new_puzzle}
    else
      if puzzle == new_puzzle do
        {:error, "Insufficient data"}
      else
        solve_iterations(new_puzzle, depth - 1)
      end
    end
  end

  defp puzzle_complete?(puzzle) do
    puzzle.pieces != nil and puzzle.rows != nil and puzzle.columns != nil and
      puzzle.format != nil and puzzle.aspect_ratio != nil and
      puzzle.border != nil and puzzle.inside != nil
  end

  defp safe_get_pieces(%{pieces: p}) when p != nil, do: p

  defp safe_get_pieces(puzzle) when puzzle.rows != nil and puzzle.columns != nil,
    do: puzzle.rows * puzzle.columns

  defp safe_get_pieces(_), do: nil

  defp safe_get_rows(%{rows: r}) when r != nil, do: r

  defp safe_get_rows(%{border: b, pieces: p, format: f})
       when b != nil and p != nil and f != nil do
    possible_rows =
      for r <- 1..ceil(:math.sqrt(p)),
          rem(p, r) == 0,
          r * 2 + div(p, r) * 2 - 4 == b,
          do: r

    case possible_rows do
      [k] -> (f == :portrait && div(p, k)) || k
      _ -> nil
    end
  end

  defp safe_get_rows(%{inside: i, aspect_ratio: 1.0}) when i != nil, do: round(:math.sqrt(i)) + 2
  defp safe_get_rows(%{inside: i, format: :square}) when i != nil, do: round(:math.sqrt(i)) + 2

  defp safe_get_rows(puzzle) when puzzle.pieces != nil and puzzle.aspect_ratio != nil,
    do: round(:math.sqrt(puzzle.pieces / puzzle.aspect_ratio))

  defp safe_get_rows(puzzle) when puzzle.columns != nil and puzzle.aspect_ratio != nil,
    do: round(puzzle.columns / puzzle.aspect_ratio)

  defp safe_get_rows(_), do: nil

  defp safe_get_columns(%{columns: c}) when c != nil, do: c

  defp safe_get_columns(puzzle) when puzzle.pieces != nil and puzzle.rows != nil,
    do: div(puzzle.pieces, puzzle.rows)

  defp safe_get_columns(puzzle) when puzzle.rows != nil and puzzle.aspect_ratio != nil,
    do: round(puzzle.rows * puzzle.aspect_ratio)

  defp safe_get_columns(_), do: nil

  defp safe_get_aspect_ratio(%{aspect_ratio: a}) when a != nil, do: a
  defp safe_get_aspect_ratio(%{format: :square}), do: 1.0

  defp safe_get_aspect_ratio(puzzle) when puzzle.pieces != nil and puzzle.rows != nil,
    do: puzzle.pieces / (puzzle.rows * puzzle.rows)

  defp safe_get_aspect_ratio(puzzle) when puzzle.pieces != nil and puzzle.columns != nil,
    do: puzzle.columns * puzzle.columns / puzzle.pieces

  defp safe_get_aspect_ratio(puzzle) when puzzle.rows != nil and puzzle.columns != nil,
    do: puzzle.columns / puzzle.rows

  defp safe_get_aspect_ratio(_), do: nil

  defp safe_get_format(%{format: f}) when f != nil, do: f

  defp safe_get_format(puzzle) when puzzle.aspect_ratio != nil do
    cond do
      puzzle.aspect_ratio > 1 -> :landscape
      puzzle.aspect_ratio == 1 -> :square
      puzzle.aspect_ratio < 1 -> :portrait
    end
  end

  defp safe_get_format(_), do: nil

  defp safe_get_border(puzzle) when puzzle.rows != nil and puzzle.columns != nil,
    do: puzzle.rows * 2 + puzzle.columns * 2 - 4

  defp safe_get_border(_), do: nil

  defp safe_get_inside(puzzle) when puzzle.rows != nil and puzzle.columns != nil,
    do: (puzzle.rows - 2) * (puzzle.columns - 2)

  defp safe_get_inside(_), do: nil
end
