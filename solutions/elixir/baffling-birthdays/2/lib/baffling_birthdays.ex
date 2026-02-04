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
  def estimated_probability_of_shared_birthday(group_size) when group_size < 2, do: 0.0

  def estimated_probability_of_shared_birthday(group_size) do
    trials = 10_000

    shared =
      1..trials
      |> Enum.count(fn _ ->
        group = random_birthdates(group_size)
        shared_birthday?(group)
      end)

    1.0 * shared / trials * 100
  end

  defp random_date do
    Date.add(~D[0001-01-01], Enum.random(0..364))
  end
end
