defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    number = :math.sqrt(x * x + y * y)

    cond do
      number <= 1 ->
        10

      number <= 5 ->
        5

      number <= 10 ->
        1

      true ->
        0
    end
  end
end
