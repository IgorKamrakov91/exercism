defmodule Clock do
  @type t() :: %__MODULE__{hour: integer, minute: integer}
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: t()
  def new(hour, minute) do
    all_minutes = hour * 60 + minute

    %Clock{
      hour: Integer.mod(floor(all_minutes / 60), 24),
      minute: Integer.mod(all_minutes, 60)
    }
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(t(), integer) :: t()
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end
end

defimpl String.Chars, for: Clock do
  @spec to_string(Clock) :: String
  def to_string(clock) do
    "#{String.pad_leading(Integer.to_string(clock.hour), 2, "0")}:#{String.pad_leading(Integer.to_string(clock.minute), 2, "0")}"
  end
end
