defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) when number < 2, do: []
  def factors_for(number), do: do_factors(number, 2)

  defp do_factors(1, _f), do: []

  defp do_factors(number, f) when rem(number, f) == 0 do
    [f | do_factors(div(number, f), f)]
  end

  defp do_factors(number, f) when f * f > number do
    [number]
  end

  defp do_factors(number, f), do: do_factors(number, f + 1)
end
