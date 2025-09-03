defmodule Year do
  @doc """
  Returns whether 'year' is a leap year.

  A leap year occurs:

  on every year that is evenly divisible by 4
    except every year that is evenly divisible by 100
      unless the year is also evenly divisible by 400
  """
  @spec leap_year?(non_neg_integer) :: boolean
  def leap_year?(year) do
    even(year, 400) || (even(year, 4) and !even(year, 100))
  end

  defp even(num, divider) do
    rem(num, divider) == 0
  end
end
