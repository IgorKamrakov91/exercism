defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value([], _max_w), do: 0

  def maximum_value([head | tail], max_w) when head.weight > max_w do
    maximum_value(tail, max_w)
  end

  def maximum_value([head | tail], max_w) do
    [
      head.value + maximum_value(tail, max_w - head.weight),
      maximum_value(tail, max_w)
    ]
    |> Enum.max()
  end
end
