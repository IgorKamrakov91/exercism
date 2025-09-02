defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  use Bitwise

  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    []
    |> add_action(code, 0b1, "wink")
    |> add_action(code, 0b10, "double blink")
    |> add_action(code, 0b100, "close your eyes")
    |> add_action(code, 0b1000, "jump")
    |> add_action(code, 0b10000, &Enum.reverse/1)
  end

  defp add_action(list, code, bit, action) do
    is_bit_set? = (code &&& bit) == bit

    if is_bit_set? do
      cond do
        is_binary(action) -> list ++ [action]
        is_function(action) -> action.(list)
      end
    else
      list
    end
  end
end
