defmodule BafflingBirthdays do
  @moduledoc """
  Estimate the probability of shared birthdays in a group of people.
  """

  @spec shared_birthday?(birthdates :: [Date.t()]) :: boolean()
  def shared_birthday?(birthdates) when length(birthdates) < 2 do
    false
  end

  def shared_birthday?(birthdates) do
    dates =
      birthdates
      |> Enum.map(fn date -> {date.month, date.day} end)
      |> Enum.into(MapSet.new())

    MapSet.size(dates) != length(birthdates)
  end

  @spec random_birthdates(group_size :: integer()) :: [Date.t()]
  def random_birthdates(group_size) do
    for _ <- 1..group_size, do: random_date()
  end

  @spec estimated_probability_of_shared_birthday(group_size :: integer()) :: float()
  def estimated_probability_of_shared_birthday(group_size) when group_size < 2, do: 0

  def estimated_probability_of_shared_birthday(group_size) do
    trials = 100

    shared =
      1..trials
      |> Enum.count(fn _ ->
        group = random_birthdates(group_size)
        shared_birthday?(group)
      end)

    1.0 * shared / trials * 100
  end

  defp random_date do
    year = Enum.random(1..2026)
    month = Enum.random(1..12)
    day = Enum.random(1..Date.days_in_month(Date.new!(year, month, 1)))

    date = Date.new!(year, month, day)

    if Date.leap_year?(date) do
      random_date()
    else
      date
    end
  end
end
