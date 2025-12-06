defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []
  def primes_to(limit) do
    sieve(Enum.to_list(2..limit), limit, [])
  end

  defp sieve([], _, acc), do: acc
  defp sieve([next_prime | rest], limit, acc) do
    # list with the step of a next_prime
    to_remove = Enum.to_list(next_prime..limit//next_prime)
    sieve(rest -- to_remove, limit, acc ++ [next_prime])
  end
end
