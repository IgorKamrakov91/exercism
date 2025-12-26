defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(?A), do: "A\n"

  def build_shape(letter) do
    width = (letter - ?A) * 2

    Enum.join(
      Enum.map(?A..letter, &shape_line(&1, width)) ++
        Enum.map((letter - 1)..?A, &shape_line(&1, width))
    )
  end

  defp shape_line(?A, width) do
    pad = String.duplicate(" ", trunc(width / 2))
    pad <> "A" <> pad <> "\n"
  end

  defp shape_line(letter, width) do
    string = to_string([letter])
    mid_pad = String.duplicate(" ", (letter - ?A) * 2 - 1)
    pad = String.duplicate(" ", trunc(width / 2) - (letter - ?A))

    pad <> string <> mid_pad <> string <> pad <> "\n"
  end
end
