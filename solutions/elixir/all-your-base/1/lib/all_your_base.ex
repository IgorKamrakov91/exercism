defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_, input_base, _) when input_base < 2, do: {:error, "input base must be >= 2"}

  def convert(_, _, output_base) when output_base < 2, do: {:error, "output base must be >= 2"}

  def convert(digits, input_base, output_base) do
    cond do
      Enum.any?(digits, fn number -> number < 0 or number >= input_base end) ->
        {:error, "all digits must be >= 0 and < input base"}

      true ->
        {:ok, digits |> Integer.undigits(input_base) |> Integer.digits(output_base)}
    end
  end
end
