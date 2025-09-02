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
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    digit = String.to_integer(Integer.to_string(code, 2))

    case digit do
      1000 when digit / 1000 >= 1 -> ["jump"]
      100 when digit / 100 >= 1 -> ["close your eyes"]
      10 when digit / 10 >= 1 -> ["double blink"]
      1 when digit / 1 >= 1 -> ["wink"]
    end
  end
end
