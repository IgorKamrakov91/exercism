defmodule SwiftScheduling do
  @doc """
  Convert delivery date descriptions to actual delivery dates, based on when the meeting started.
  """
  @spec delivery_date(NaiveDateTime.t(), String.t()) :: NaiveDateTime.t()
  def delivery_date(meeting_date, "NOW"), do: NaiveDateTime.add(meeting_date, 2, :hour)

  def delivery_date(meeting_date, "ASAP") when meeting_date.hour < 13 do
    %{meeting_date | hour: 17, minute: 0}
  end

  def delivery_date(meeting_date, "ASAP") do
    NaiveDateTime.add(%{meeting_date | hour: 13, minute: 0}, 1, :day)
  end

  def delivery_date(meeting_date, "EOW"), do: eow_target(meeting_date)

  def delivery_date(meeting_date, description) do
    case parse_description(description) do
      {:month, m} -> month_target(meeting_date, m)
      {:quarter, q} -> quarter_target(meeting_date, q)
      :invalid -> raise ArgumentError, "invalid description"
    end
  end

  defp parse_description(<<_::binary>> = desc) do
    parse_month(desc) || parse_quarter(desc) || :invalid
  end

  defp parse_month(desc) do
    with [_, digits] <- Regex.run(~r/^(\d+)M$/, desc),
         {m, ""} <- Integer.parse(digits),
         true <- m in 1..12 do
      {:month, m}
    else
      _ -> nil
    end
  end

  defp parse_quarter(desc) do
    with [_, digits] <- Regex.run(~r/^Q(\d+)$/, desc),
         {q, ""} <- Integer.parse(digits),
         true <- q in 1..4 do
      {:quarter, q}
    else
      _ -> nil
    end
  end

  defp eow_target(meeting_date) do
    dow = meeting_date |> NaiveDateTime.to_date() |> Date.day_of_week()
    {days_to_add, target_hour} = eow_calculate(dow)

    meeting_date
    |> Map.put(:hour, target_hour)
    |> Map.put(:minute, 0)
    |> NaiveDateTime.add(days_to_add, :day)
  end

  defp eow_calculate(dow) when dow in 1..3, do: {5 - dow, 17}
  defp eow_calculate(dow), do: {7 - dow, 20}

  defp month_target(%NaiveDateTime{year: y, month: m0} = _meeting_date, m) do
    year = if m0 < m, do: y, else: y + 1
    year |> first_of_month_at_8am(m) |> shift_to_weekday_morning()
  end

  defp first_of_month_at_8am(year, month),
    do: NaiveDateTime.new!(year, month, 1, 8, 0, 0)

  defp quarter_target(%NaiveDateTime{year: y, month: m0}, q) do
    current_q = div(m0 - 1, 3) + 1
    year = if current_q <= q, do: y, else: y + 1
    end_month = quarter_end_month(q)

    end_date =
      year
      |> Date.new!(end_month, 1)
      |> Date.end_of_month()
      |> last_workday_of_month_end()

    NaiveDateTime.new!(end_date.year, end_date.month, end_date.day, 8, 0, 0)
  end

  defp quarter_end_month(1), do: 3
  defp quarter_end_month(2), do: 6
  defp quarter_end_month(3), do: 9
  defp quarter_end_month(4), do: 12

  defp shift_to_weekday_morning(dt) do
    case dt |> NaiveDateTime.to_date() |> Date.day_of_week() do
      # Saturday -> Monday
      6 -> dt |> NaiveDateTime.add(2, :day) |> set_time(8, 0)
      # Sunday -> Monday
      7 -> dt |> NaiveDateTime.add(1, :day) |> set_time(8, 0)
      _ -> set_time(dt, 8, 0)
    end
  end

  defp last_workday_of_month_end(date) do
    case Date.day_of_week(date) do
      6 -> Date.add(date, -1)
      7 -> Date.add(date, -2)
      _ -> date
    end
  end

  defp set_time(%NaiveDateTime{} = dt, h, m), do: %{dt | hour: h, minute: m}
end
