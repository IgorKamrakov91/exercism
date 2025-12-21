defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    [sum | addends] = words = parse(puzzle)
    letters = words |> List.flatten() |> Enum.uniq()
    first_letters = words |> Enum.map(&hd/1) |> Enum.uniq()
    problem = %{addends: addends, sum: sum, first_letters: first_letters}

    do_solve(letters, Enum.to_list(0..9), %{}, problem)
  end

  defp do_solve([], _numbers, solution, %{addends: addends, sum: sum}) do
    if sum(addends, solution) == to_number(sum, solution) do
      solution
    end
  end

  defp do_solve([letter | letters], numbers, solution, problem) do
    Enum.find_value(numbers, fn number ->
      unless leading_zero?(number, letter, problem) do
        remaining_numbers = List.delete(numbers, number)
        solution = put_in(solution[letter], number)

        do_solve(letters, remaining_numbers, solution, problem)
      end
    end)
  end

  defp parse(puzzle) do
    [left, right] = String.split(puzzle, " == ")
    addends = left |> String.split(" + ") |> Enum.map(&String.to_charlist/1)
    sum = String.to_charlist(right)

    [sum | addends]
  end

  defp sum(addends, solution) do
    Enum.reduce(addends, 0, fn addend, sum ->
      sum + to_number(addend, solution)
    end)
  end

  defp to_number(letters, numbers) do
    letters |> Enum.map(& numbers[&1]) |> Integer.undigits()
  end

  defp leading_zero?(number, letter, problem) do
    number == 0 and letter in problem.first_letters
  end
end
