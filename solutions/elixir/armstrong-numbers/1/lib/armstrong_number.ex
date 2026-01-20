defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = Integer.digits(number)
    size = length(digits)
    result = Enum.reduce(digits, 0, fn num, acc -> acc + Integer.pow(num, size) end)

    number == result
  end
end
