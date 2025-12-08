defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number < 0 or number >= 1_000_000_000_000 do
    {:error, "number is out of range"}
  end

  def in_english(0), do: {:ok, "zero"}

  def in_english(number) do
    {:ok, number |> say() |> Enum.join(" ")}
  end

  defp say(0), do: []

  defp say(n) when n < 20, do: [ones(n)]

  defp say(n) when n < 100 do
    tens = div(n, 10)
    rest = rem(n, 10)

    if rest == 0 do
      [tens(tens)]
    else
      [tens(tens) <> "-" <> ones(rest)]
    end
  end

  defp say(n) when n < 1_000, do: scale(n, 100, "hundred")
  defp say(n) when n < 1_000_000, do: scale(n, 1_000, "thousand")
  defp say(n) when n < 1_000_000_000, do: scale(n, 1_000_000, "million")
  defp say(n), do: scale(n, 1_000_000_000, "billion")

  defp scale(n, divisor, label) do
    count = div(n, divisor)
    remainder = rem(n, divisor)
    say(count) ++ [label] ++ say(remainder)
  end

  defp ones(1), do: "one"
  defp ones(2), do: "two"
  defp ones(3), do: "three"
  defp ones(4), do: "four"
  defp ones(5), do: "five"
  defp ones(6), do: "six"
  defp ones(7), do: "seven"
  defp ones(8), do: "eight"
  defp ones(9), do: "nine"
  defp ones(10), do: "ten"
  defp ones(11), do: "eleven"
  defp ones(12), do: "twelve"
  defp ones(13), do: "thirteen"
  defp ones(14), do: "fourteen"
  defp ones(15), do: "fifteen"
  defp ones(16), do: "sixteen"
  defp ones(17), do: "seventeen"
  defp ones(18), do: "eighteen"
  defp ones(19), do: "nineteen"

  defp tens(2), do: "twenty"
  defp tens(3), do: "thirty"
  defp tens(4), do: "forty"
  defp tens(5), do: "fifty"
  defp tens(6), do: "sixty"
  defp tens(7), do: "seventy"
  defp tens(8), do: "eighty"
  defp tens(9), do: "ninety"
end
