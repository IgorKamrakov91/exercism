defmodule RotationalCipher do
  @number_of_characters 26

  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    String.to_charlist(text)
    |> Enum.map(fn char -> translate(char, shift) end)
    |> List.to_string
  end

  def translate(char, shift) when char in ?a..?z do
    ?a + Integer.mod(char - ?a + shift, @number_of_characters)
  end

  def translate(char, shift) when char in ?A..?Z do
    ?A + Integer.mod(char - ?A + shift, @number_of_characters)
  end

  def translate(char, _) do
    char
  end
end
