defmodule LibraryFees do
  @midday 12

  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(datetime) do
    datetime.hour < @midday
  end

  def return_date(checkout_datetime) do
    added_days = if before_noon?(checkout_datetime), do: 28, else: 29
    NaiveDateTime.add(checkout_datetime, added_days, :day) |> NaiveDateTime.to_date()
  end

  def days_late(planned_return_date, actual_return_datetime) do
    return_date = NaiveDateTime.to_date(actual_return_datetime)
    result = Date.diff(return_date, planned_return_date)
    if result > 0, do: result, else: 0
  end

  def monday?(datetime) do
    day_of_week = NaiveDateTime.to_date(datetime) |> Date.day_of_week()
    if day_of_week == 1, do: true, else: false
  end

  def calculate_late_fee(checkout, return, rate) do
    checkout_date = datetime_from_string(checkout)
    return_date = datetime_from_string(return)
    planned_return = return_date(checkout_date)

    late_days = days_late(planned_return, return_date)
    result = late_days * rate
    if monday?(return_date), do: trunc(result / 2), else: result
  end
end
