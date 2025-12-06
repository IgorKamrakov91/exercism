defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    get_all_days(year, month)
    |> on_day(weekday)
    |> in_week(schedule)
  end

  defp get_all_days(year, month) do
    days = Date.new!(year, month, 1)
    start_date = Date.beginning_of_month(days)
    end_date = Date.end_of_month(days)
    for day <- Date.range(start_date, end_date), do: day
  end

  defp on_day(month, weekday) do
    Enum.filter(month, fn date ->
      Calendar.strftime(date, "%A") == String.capitalize(to_string(weekday))
    end)
  end

  defp in_week(days, schedule) do
    case schedule do
      :first -> Enum.at(days, 0)
      :second -> Enum.at(days, 1)
      :third -> Enum.at(days, 2)
      :fourth -> Enum.at(days, 3)
      :last -> Enum.at(days, -1)
      :teenth -> Enum.find(days, fn date ->
        date.day > 12 and date.day < 20
      end)
    end
  end
end
