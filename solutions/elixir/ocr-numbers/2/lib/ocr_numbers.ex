defmodule OcrNumbers do
  @rows 4
  @cols 3

  @errors %{
    lines: {:error, "invalid line count"},
    cols: {:error, "invalid column count"}
  }

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

  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(lines) do
    with :ok <- valid_lines?(lines),
         :ok <- valid_cols?(lines) do
      lines
      |> Enum.chunk_every(@rows)
      |> Enum.map(&decode_page/1)
      |> Enum.join(",")
      |> then(&{:ok, &1})
    end
  end

  defp decode_page([r1, r2, r3, r4]) do
    digits_count = div(String.length(r1), @cols)

    0..(digits_count - 1)
    |> Enum.map(fn i ->
      start = i * @cols

      pattern = [
        String.slice(r1, start, @cols),
        String.slice(r2, start, @cols),
        String.slice(r3, start, @cols),
        String.slice(r4, start, @cols)
      ]

      Map.get(@numbers, pattern, "?")
    end)
    |> Enum.join()
  end

  defp valid_lines?(lines) do
    if rem(length(lines), @rows) == 0, do: :ok, else: @errors.lines
  end

  defp valid_cols?(lines) do
    if Enum.all?(lines, fn l -> rem(String.length(l), @cols) == 0 end),
      do: :ok,
      else: @errors.cols
  end
end
