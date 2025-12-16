defmodule Say do
  @doc """
  Translate a positive integer into English.
  """

  @numbers %{
     0 => "zero",
     1 => "one",
     2 => "two",
     3 => "three",
     4 => "four",
     5 => "five",
     6 => "six",
     7 => "seven",
     8 => "eight",
     9 => "nine",
     10 => "ten",
     11 => "eleven",
     12 => "twelve",
     13 => "thirteen",
     14 => "fourteen",
     15 => "fifteen",
     16 => "sixteen",
     17 => "seventeen",
     18 => "eighteen",
     19 => "nineteen"
   }
   @tens %{
     2 => "twenty",
     3 => "thirty",
     4 => "forty",
     5 => "fifty",
     6 => "sixty",
     7 => "seventy",
     8 => "eighty",
     9 => "ninety"
   }

  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number not in 0..999_999_999_999 do
    {:error, "number is out of range"}
  end

  def in_english(number) do
    {:ok, do_in_english(number, "")}
  end

  defp do_in_english(0, ""), do: "zero"
  defp do_in_english(0, acc), do: String.trim(acc)
  defp do_in_english(n, acc) when n < 20, do: do_in_english(0, acc <> @numbers[n])

  defp do_in_english(n, acc) when n < 100 do
    tens = div(n, 10)
    rest = n - (tens * 10)

    cond do
      rest == 0 -> do_in_english(rest, acc <> @tens[tens])
      true -> do_in_english(rest, acc <> @tens[tens] <> "-")
    end
  end

  defp do_in_english(n, acc) when n < 1000 do
    do_part(n, acc, 100, "hundred")
  end
  defp do_in_english(n, acc) when n < 1_000_000 do
    do_part(n, acc, 1_000, "thousand")
  end
  defp do_in_english(n, acc) when n < 1_000_000_000 do
    do_part(n, acc, 1_000_000, "million")
  end
  defp do_in_english(n, acc) when n < 1_000_000_000_000 do
    do_part(n, acc, 1_000_000_000, "billion")
  end

  defp do_part(n, acc, divisor, text) do
    unit = div(n, divisor)
    rest = n - (unit * divisor)

    do_in_english(rest, acc <> do_in_english(unit, "") <> " #{text} ")
  end
end
