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
    target_weekday = weekday_to_number(weekday)

    year
    |> get_days_in_month(month)
    |> filter_by_weekday(target_weekday)
    |> select_schedule(schedule)
  end

  defp get_days_in_month(year, month) do
    date = Date.new!(year, month, 1)
    days_in_month = Date.days_in_month(date)
    
    for day <- 1..days_in_month, do: Date.new!(year, month, day)
  end

  defp filter_by_weekday(dates, target_weekday) do
    Enum.filter(dates, fn date -> Date.day_of_week(date) == target_weekday end)
  end

  defp select_schedule(dates, :first), do: List.first(dates)
  defp select_schedule(dates, :second), do: Enum.at(dates, 1)
  defp select_schedule(dates, :third), do: Enum.at(dates, 2)
  defp select_schedule(dates, :fourth), do: Enum.at(dates, 3)
  defp select_schedule(dates, :last), do: List.last(dates)

  defp select_schedule(dates, :teenth) do
    Enum.find(dates, fn date -> date.day >= 13 and date.day <= 19 end)
  end

  defp weekday_to_number(:monday), do: 1
  defp weekday_to_number(:tuesday), do: 2
  defp weekday_to_number(:wednesday), do: 3
  defp weekday_to_number(:thursday), do: 4
  defp weekday_to_number(:friday), do: 5
  defp weekday_to_number(:saturday), do: 6
  defp weekday_to_number(:sunday), do: 7
end