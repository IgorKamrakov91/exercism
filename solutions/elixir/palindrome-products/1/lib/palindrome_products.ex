defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)

  def generate(max_factor, min_factor) when max_factor < min_factor do
    raise ArgumentError
  end

  def generate(max_factor, min_factor) do
    palindromes(min_factor, max_factor)
    |> Enum.group_by(fn {product, _} -> product end, fn {_, factors} -> factors end)
    |> Enum.into(%{})
  end

  defp palindromes(min_factor, max_factor) do
    for a <- min_factor..max_factor,
        b <- a..max_factor,
        product = a * b,
        palindrome?(product) do
      {product, [a, b]}
    end
  end

  defp palindrome?(number) do
    digits = Integer.digits(number)
    digits == Enum.reverse(digits)
  end
end
