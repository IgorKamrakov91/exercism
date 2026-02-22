defmodule TwoBucket do
  defstruct [:bucket_one, :bucket_two, :moves]
  @type t :: %TwoBucket{bucket_one: integer, bucket_two: integer, moves: integer}

  @doc """
  Find the quickest way to fill a bucket with some amount of water from two buckets of specific sizes.
  """
  @spec measure(
          size_one :: integer,
          size_two :: integer,
          goal :: integer,
          start_bucket :: :one | :two
        ) :: {:ok, TwoBucket.t()} | {:error, :impossible}
  def measure(size_one, size_two, goal, start_bucket) do
    cond do
      goal > max(size_one, size_two) ->
        {:error, :impossible}

      rem(goal, Integer.gcd(size_one, size_two)) != 0 ->
        {:error, :impossible}

      true ->
        do_measure(size_one, size_two, goal, start_bucket)
    end
  end

  defp do_measure(size_one, size_two, goal, start_bucket) do
    {initial_b1, initial_b2} =
      if start_bucket == :one, do: {size_one, 0}, else: {0, size_two}

    forbidden = if start_bucket == :one, do: {0, size_two}, else: {size_one, 0}

    queue = :queue.from_list([{initial_b1, initial_b2, 1}])
    visited = MapSet.new([forbidden, {initial_b1, initial_b2}])

    bfs(queue, visited, size_one, size_two, goal)
  end

  defp bfs(queue, visited, size_one, size_two, goal) do
    case :queue.out(queue) do
      {{:value, {b1, b2, moves}}, queue} ->
        if b1 == goal or b2 == goal do
          {:ok, %TwoBucket{bucket_one: b1, bucket_two: b2, moves: moves}}
        else
          next_states =
            [
              {size_one, b2},
              {b1, size_two},
              {0, b2},
              {b1, 0},
              pour(b1, b2, size_one, size_two, :one_to_two),
              pour(b1, b2, size_one, size_two, :two_to_one)
            ]
            |> Enum.reject(fn state -> MapSet.member?(visited, state) end)

          new_visited = Enum.reduce(next_states, visited, &MapSet.put(&2, &1))
          new_queue = Enum.reduce(next_states, queue, fn {nb1, nb2}, q ->
            :queue.in({nb1, nb2, moves + 1}, q)
          end)

          bfs(new_queue, new_visited, size_one, size_two, goal)
        end

      {:empty, _} ->
        {:error, :impossible}
    end
  end

  defp pour(b1, b2, _size_one, size_two, :one_to_two) do
    amount = min(b1, size_two - b2)
    {b1 - amount, b2 + amount}
  end

  defp pour(b1, b2, size_one, _size_two, :two_to_one) do
    amount = min(b2, size_one - b1)
    {b1 + amount, b2 - amount}
  end
end
