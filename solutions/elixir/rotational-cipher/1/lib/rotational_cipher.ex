defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    first_letter = String.first(text)
    {index, _length} = :binary.match(alphabet, first_letter)

    Enum.to_list(text, fn x -> String.at(alphabet, round_index(index + shift))end)
  end

  def round_index(index) do
    if index >= 26 do
      index - 26
    else
      index
    end
  end
end
