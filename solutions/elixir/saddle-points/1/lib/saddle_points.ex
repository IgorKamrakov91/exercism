defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&row/1)
  end

  defp row(str) do
    str
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str |> rows() |> Enum.zip_with(& &1)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    row_maxs = str |> rows() |> Enum.map(&Enum.max/1) |> Enum.with_index(1)
    col_mins = str |> columns() |> Enum.map(&Enum.min/1) |> Enum.with_index(1)

    for {row_max, row} <- row_maxs,
        {col_min, col} <- col_mins,
        row_max == col_min,
        do: {row, col}
  end
end
