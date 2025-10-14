defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @max_point_in_frame 10
  @max_frames 10

  defstruct rolls: [],
            frames: [],
            bonus_rolls: []

  @spec start() :: any
  def start, do: %Bowling{}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll(_game, roll) when roll < 0, do: {:error, "Negative roll is invalid"}

  def roll(_game, roll) when roll > @max_point_in_frame,
    do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%Bowling{rolls: rolls} = _game, roll) do
    {frames, bonus_rolls} =
      (rolls ++ [roll])
      |> make_frames()
      |> extract_bonus_rolls()

    last_frame = List.last(frames)
    frames_count = Enum.count(frames)
    bonus_rolls_count = Enum.count(bonus_rolls)

    cond do
      frames_count == @max_frames && !strike_or_spare?(last_frame) && bonus_rolls_count > 0 ->
        {:error, "Cannot roll after game is over"}

      second_bonus_roll_cant_be_strrike?(bonus_rolls) ||
          pin_count_exceeds?(last_frame) ->
        {:error, "Pin count exceeds pins on the lane"}

      (spare?(last_frame) && bonus_rolls_count > 1) ||
          (strike?(last_frame) && bonus_rolls_count > 2) ->
        {:error, "Cannot roll after game is over"}

      true ->
        {:ok,
         %Bowling{
           rolls: rolls ++ [roll],
           frames: frames,
           bonus_rolls: bonus_rolls
         }}
    end
  end

  defp pin_count_exceeds?(rolls) when is_tuple(rolls), do: Tuple.sum(rolls) > @max_point_in_frame

  defp second_bonus_roll_cant_be_strrike?([roll1, roll2]),
    do: roll1 < @max_point_in_frame && roll1 + roll2 > @max_point_in_frame

  defp second_bonus_roll_cant_be_strrike?(_), do: false

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @spec score(any) :: {:ok, integer} | {:error, String.t()}
  def score(%Bowling{frames: frames}) when length(frames) < 10,
    do: {:error, "Score cannot be taken until the end of the game"}

  def score(%Bowling{rolls: rolls, frames: frames, bonus_rolls: bonus_rolls}) do
    last_frame = List.last(frames)

    cond do
      (spare?(last_frame) && Enum.count(bonus_rolls) < 1) ||
          (strike?(last_frame) && Enum.count(bonus_rolls) < 2) ->
        {:error, "Score cannot be taken until the end of the game"}

      true ->
        score = calculate_score(rolls)
        {:ok, score}
    end
  end

  defp calculate_score([]), do: 0

  defp calculate_score([roll1, roll2, roll3 | t] = rolls) do
    cond do
      roll1 == @max_point_in_frame ->
        foo(rolls, [roll2, roll3])

      roll1 + roll2 == @max_point_in_frame ->
        foo(rolls, [roll3])

      true ->
        roll1 + roll2 + calculate_score([roll3] ++ t)
    end
  end

  defp calculate_score([roll1, roll2 | t]) do
    roll1 + roll2 + calculate_score(t)
  end

  defp foo([roll1, roll2, roll3 | t], add) do
    roll1 + roll2 + roll3 +
      if Enum.count(t) > 0,
        do: calculate_score(add ++ t),
        else: calculate_score(t)
  end

  defp strike?({roll}) when roll == @max_point_in_frame, do: true
  defp strike?(_), do: false

  defp spare?({roll1, roll2}) when roll1 + roll2 == @max_point_in_frame, do: true
  defp spare?(_), do: false

  defp strike_or_spare?(rolls) when is_tuple(rolls), do: strike?(rolls) || spare?(rolls)
  defp strike_or_spare?(_rolls), do: false

  defp make_frames([]), do: []
  # def make_frames(frames) when length(frames)
  defp make_frames([@max_point_in_frame | t]),
    do: [{@max_point_in_frame}] ++ make_frames(t)

  defp make_frames([roll1, roll2 | t]),
    do: [{roll1, roll2}] ++ make_frames(t)

  defp make_frames([roll | t]), do: [{roll}] ++ make_frames(t)

  defp extract_bonus_rolls(frames) do
    {frames, bonus_rolls} = Enum.split(frames, @max_frames)

    {frames, Enum.flat_map(bonus_rolls, &Tuple.to_list/1)}
  end
end
