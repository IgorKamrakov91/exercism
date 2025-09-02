defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    palette_bit_size_helper(color_count, 0, 1)
  end

  defp palette_bit_size_helper(color_count, bits, power_of_two) do
    if power_of_two >= color_count do
      bits
    else
      palette_bit_size_helper(color_count, bits + 1, power_of_two * 2)
    end
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2, 1::2, 2::2, 3::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bit_size = palette_bit_size(color_count)
    <<pixel_color_index::size(bit_size), picture::bitstring>>
  end

  def get_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)

    case picture do
      <<first_pixel::size(bit_size), _rest::bitstring>> -> first_pixel
      <<>> -> nil
    end
  end

  def drop_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)

    case picture do
      <<_first_pixel::size(bit_size), rest::bitstring>> -> rest
      <<>> -> <<>>
    end
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
