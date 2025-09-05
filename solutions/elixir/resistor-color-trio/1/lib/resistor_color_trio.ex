defmodule ResistorColorTrio do
  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label(colors) do
    [first_color, second_color, multiplier_color | _] = colors

    first_digit = color_to_number(first_color)
    second_digit = color_to_number(second_color)
    multiplier = color_to_number(multiplier_color)

    base_value = first_digit * 10 + second_digit

    total_ohms = base_value * :math.pow(10, multiplier)

    format_resistance(trunc(total_ohms))
  end

  defp color_to_number(color) do
    case color do
      :black -> 0
      :brown -> 1
      :red -> 2
      :orange -> 3
      :yellow -> 4
      :green -> 5
      :blue -> 6
      :violet -> 7
      :grey -> 8
      :white -> 9
    end
  end

  defp format_resistance(ohms) when ohms < 1000 do
    {ohms, :ohms}
  end

  defp format_resistance(ohms) when ohms < 1_000_000 do
    {div(ohms, 1000), :kiloohms}
  end

  defp format_resistance(ohms) when ohms < 1_000_000_000 do
    {div(ohms, 1_000_000), :megaohms}
  end

  defp format_resistance(ohms) do
    {div(ohms, 1_000_000_000), :gigaohms}
  end
end
