defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    trimmed = String.trim(input)

    cond do
      trimmed == "" -> "Fine. Be that way!"
      yelling?(trimmed) && question?(trimmed) -> "Calm down, I know what I'm doing!"
      yelling?(trimmed) -> "Whoa, chill out!"
      question?(trimmed) -> "Sure."
      true -> "Whatever."
    end
  end

  defp question?(input) do
    String.ends_with?(input, "?")
  end

  defp yelling?(input) do
    has_letters = String.match?(input, ~r/\p{L}/u)
    has_letters && input == String.upcase(input)
  end
end
