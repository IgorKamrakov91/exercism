defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    flags = update_flags(flags, length(files))

    files
    |> Enum.map(&grep_file(pattern, flags, &1))
    |> List.flatten()
    |> Enum.join()
  end

  defp update_flags(flags, 1), do: flags
  defp update_flags(flags, _), do: ["-f" | flags]

  defp grep_file(pattern, flags, file) do
    pattern = compile(pattern, flags)

    file
    |> File.stream!()
    |> handle_linenumber(flags)
    |> handle_filter(pattern, flags)
    |> handle_filename(flags)
    |> Enum.to_list()
  end

  defp compile(pattern, flags) do
    cond do
      "-i" in flags && "-x" in flags ->
        Regex.compile!(pattern <> "\n", [:caseless, :multiline])

      "-i" in flags ->
        Regex.compile!(pattern, [:caseless])

      "-x" in flags ->
        Regex.compile!(pattern <> "\n", [:multiline])

      true ->
        Regex.compile!(pattern)
    end
  end

  defp handle_linenumber(stream, flags) do
    if "-n" in flags do
      stream
      |> Stream.with_index()
      |> Stream.map(fn {line, index} ->
        "#{index + 1}:#{line}"
      end)
    else
      stream
    end
  end

  defp handle_filter(stream, pattern, flags) do
    func_name = if "-v" in flags, do: :reject, else: :filter
    apply(Stream, func_name, [stream, &(&1 =~ pattern)])
  end

  defp handle_filename(stream, flags) do
    cond do
      "-l" in flags ->
        stream |> Stream.map(fn _ -> "#{stream.enum.path}\n" end) |> Stream.uniq()

      "-f" in flags ->
        stream |> Stream.map(fn line -> "#{stream.enum.path}:#{line}" end)

      true ->
        stream
    end
  end
end
