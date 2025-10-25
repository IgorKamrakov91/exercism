defmodule Transmission do
  @doc """
  Return the transmission sequence for a message.
  """
  @spec get_transmit_sequence(binary()) :: binary()
  def get_transmit_sequence(message) do
    do_code_sequence(message, "")
  end

  defp do_code_sequence("", ret), do: ret

  defp do_code_sequence(<<t::7, rest::bits>>, ret) do
    if even_count_of_1?(<<t::7>>) do
      do_code_sequence(rest, <<ret::bits, t::7, 0::1>>)
    else
      do_code_sequence(rest, <<ret::bits, t::7, 1::1>>)
    end
  end

  defp do_code_sequence(<<bits::bits>>, ret) do
    size = bit_size(bits)
    pading = <<0::size(7 - size)>>

    if even_count_of_1?(bits) do
      <<ret::bits, bits::bits, pading::bits, 0::1>>
    else
      <<ret::bits, bits::bits, pading::bits, 1::1>>
    end
  end

  defp even_count_of_1?(bitstring) do
    count_of_1 =
      for <<bit::1 <- bitstring>>, reduce: 0 do
        acc -> acc + bit
      end

    rem(count_of_1, 2) == 0
  end

  @doc """
  Return the message decoded from the received transmission.
  """
  @spec decode_message(binary()) :: {:ok, binary()} | {:error, String.t()}
  @error_ret {:error, "wrong parity"}
  def decode_message(received_data) do
    if bit_size(received_data) |> rem(8) == 0 do
      do_decode_message(received_data, "")
    else
      @error_ret
    end
  end

  defp do_decode_message("", ret), do: {:ok, ret}

  defp do_decode_message(<<word::8>>, ret) do
    if !even_count_of_1?(<<word::8>>) do
      @error_ret
    else
      rest_size = 8 - (bit_size(ret) |> rem(8))
      <<rest::size(rest_size), _::bits>> = <<word::8>>
      {:ok, <<ret::bits, rest::size(rest_size)>>}
    end
  end

  defp do_decode_message(<<word::8, rest::bytes>>, ret) do
    if even_count_of_1?(<<word::8>>) do
      <<f::7, _::1>> = <<word::8>>
      do_decode_message(rest, <<ret::bits, f::7>>)
    else
      @error_ret
    end
  end
end
