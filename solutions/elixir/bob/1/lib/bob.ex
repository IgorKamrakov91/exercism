defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    trimmed = String.trim(input)

    cond do
      trimmed == "" -> "Fine. Be that way!"
      is_yelling?(trimmed) && is_question?(trimmed) -> "Calm down, I know what I'm doing!"
      is_yelling?(trimmed) -> "Whoa, chill out!"
      is_question?(trimmed) -> "Sure."
      true -> "Whatever."
    end
  end

  defp is_question?(input) do
    String.ends_with?(input, "?")
  end

  defp is_yelling?(input) do
    has_letters = String.match?(input, ~r/\p{L}/u)
    has_letters && input == String.upcase(input)
  end
end
