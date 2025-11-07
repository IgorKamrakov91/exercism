defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true

  def chain?(dominoes) do
    Enum.any?(Enum.with_index(dominoes), fn {domino, index} ->
      remaining = List.delete_at(dominoes, index)

      domino
      |> orientations()
      |> Enum.any?(fn {start, current} ->
        search(remaining, start, current)
      end)
    end)
  end

  defp search([], start, current), do: current == start

  defp search(dominoes, start, current) do
    Enum.any?(Enum.with_index(dominoes), fn {domino, index} ->
      domino
      |> orientations()
      |> Enum.any?(fn {left, right} ->
        left == current and search(List.delete_at(dominoes, index), start, right)
      end)
    end)
  end

  defp orientations({a, a}), do: [{a, a}]
  defp orientations({a, b}), do: [{a, b}, {b, a}]
end
