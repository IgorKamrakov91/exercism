defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) do
    newton_raphson(radicand, radicand)
  end

  defp newton_raphson(radicand, guess) do
    new_guess = div(guess + div(radicand, guess), 2)

    if new_guess >= guess do
      guess
    else
      newton_raphson(radicand, new_guess)
    end
  end
end
