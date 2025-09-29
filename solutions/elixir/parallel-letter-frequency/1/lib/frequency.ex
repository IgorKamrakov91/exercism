defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(&process_text/1, max_concurrency: workers)
    |> Enum.reduce(%{}, fn
      {:ok, freq_map}, acc -> Map.merge(acc, freq_map, fn _, v1, v2 -> v1 + v2 end)
      _, acc -> acc
    end)
  end

  defp process_text(text) do
    text
    |> String.downcase()
    |> String.replace(~r/[^[:alpha:]]/u, "")
    |> String.codepoints()
    |> Enum.frequencies()
  end
end
