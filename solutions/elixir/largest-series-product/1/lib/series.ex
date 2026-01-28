defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_, 0), do: 1

  def largest_product(_, size) when size < 0 do
    raise ArgumentError, message: "`n` must be positive"
  end

  def largest_product(number_string, size) when size > byte_size(number_string) do
    raise ArgumentError, message: "`size` must be less then the length of `number_string`"
  end

  def largest_product(number_string, size) do
    number_string
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Stream.chunk_every(size, 1, :discard)
    |> Enum.map(&product/1)
    |> Enum.max(fn -> 0 end)
  end

  defp product(l) do
    Enum.reduce(l, 1, &*/2)
  end
end
