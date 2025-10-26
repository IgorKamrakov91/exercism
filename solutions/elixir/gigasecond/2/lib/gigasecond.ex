defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{_year, _month, _day}, {_hours, _minutes, _seconds}} = erl_datetime) do
    erl_datetime
    |> NaiveDateTime.from_erl!()
    |> NaiveDateTime.add(1_000_000_000)
    |> NaiveDateTime.to_erl()
  end
end
