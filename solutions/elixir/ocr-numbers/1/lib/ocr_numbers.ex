defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """

  @numbers %{
    [" _ ", "| |", "|_|", "   "] => "0",
    ["   ", "  |", "  |", "   "] => "1",
    [" _ ", " _|", "|_ ", "   "] => "2",
    [" _ ", " _|", " _|", "   "] => "3",
    ["   ", "|_|", "  |", "   "] => "4",
    [" _ ", "|_ ", " _|", "   "] => "5",
    [" _ ", "|_ ", "|_|", "   "] => "6",
    [" _ ", "  |", "  |", "   "] => "7",
    [" _ ", "|_|", "|_|", "   "] => "8",
    [" _ ", "|_|", " _|", "   "] => "9"
  }

  @columns 3
  @rows 4

  @invalid_lines "invalid line count"
  @invalid_columns "invalid column count"

  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    with :ok <- valid_lines?(input),
         :ok <- valid_columns?(input) do
      input
      |> split_by_empty_lines()
      |> Enum.map(&do_convert(by_digits(&1), ""))
      |> process_result([])
    end
  end

  defp valid_lines?(input) do
    if rem(length(input), @rows) == 0, do: :ok, else: {:error, @invalid_lines}
  end

  defp valid_columns?(input) do
    valid = input |> Enum.all?(&(rem(String.length(&1), @columns) == 0))

    case valid do
      true -> :ok
      false -> {:error, @invalid_columns}
    end
  end

  defp split_by_empty_lines(input) when length(input) > @rows do
    Enum.chunk_every(input, @rows)
  end

  defp split_by_empty_lines(input), do: [input]

  defp do_convert([], result), do: {:ok, result}

  defp do_convert([head | tail], result) do
    do_convert(tail, result <> Map.get(@numbers, head, "?"))
  end

  defp by_digits(input) do
    row_chunks =
      Enum.map(input, fn line ->
        line
        |> String.codepoints()
        |> Enum.chunk_every(@columns)
        |> Enum.map(&Enum.join/1)
      end)

    List.zip(row_chunks) |> Enum.map(&Tuple.to_list/1) |> Enum.map(& &1)
  end

  defp process_result([], acc) do
    {:ok, acc |> Enum.reverse() |> Enum.join(",")}
  end

  defp process_result([{:ok, number} | tail], acc) do
    process_result(tail, [number | acc])
  end
end
