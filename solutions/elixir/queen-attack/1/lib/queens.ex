defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @board Enum.map(1..64, fn _ -> "_" end) |> Enum.chunk_every(8)

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(white: {a, b}) when a < 0 or b < 0 or a > 7 or b > 7 do
    raise ArgumentError
  end

  def new(white: {a, b}, black: {a, b}) do
    raise ArgumentError
  end

  def new([white: {_, _}] = queens) do
    Enum.into(queens, %{})
  end

  def new([black: {_, _}] = queens) do
    Enum.into(queens, %{})
  end

  def new([white: {_, _}, black: {_, _}] = queens) do
    Enum.into(queens, %{})
  end

  def new(_), do: raise(ArgumentError)

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%{white: {wa, wb}, black: {ba, bb}}) do
    @board
    |> put_in([Access.at(wa), Access.at(wb)], "W")
    |> put_in([Access.at(ba), Access.at(bb)], "B")
    |> Enum.map_join("\n", &Enum.join(&1, " "))
  end

  def to_string(%{white: {a, b}}) do
    @board
    |> put_in([Access.at(a), Access.at(b)], "W")
    |> Enum.map_join("\n", &Enum.join(&1, " "))
  end

  def to_string(%{black: {a, b}}) do
    @board
    |> put_in([Access.at(a), Access.at(b)], "B")
    |> Enum.map_join("\n", &Enum.join(&1, " "))
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%{white: {a, _}, black: {a, _}}), do: true
  def can_attack?(%{white: {_, b}, black: {_, b}}), do: true
  def can_attack?(%{white: {wa, wb}, black: {ba, bb}}) when abs(wa - ba) == abs(wb - bb), do: true
  def can_attack?(_), do: false
end
