defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @default_students [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Fred",
    "Ginny",
    "Harriet",
    "Ileana",
    "Joseph",
    "Kincaid",
    "Larry"
  ]

  @spec info(String.t()) :: map
  def info(info_string) do
    info(info_string, @default_students)
  end

  @spec info(String.t(), list) :: map
  def info(info_string, student_names) do
    [row1, row2] =
      info_string
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    students =
      student_names
      |> Enum.map(&normalize_name/1)
      |> Enum.sort()

    Enum.with_index(students)
    |> Enum.map(fn {student, index} ->
      plants = Enum.slice(row1, index * 2, 2) ++ Enum.slice(row2, index * 2, 2)
      {student, List.to_tuple(Enum.map(plants, &plant/1))}
    end)
    |> Enum.into(%{})
  end

  defp normalize_name(name) when is_atom(name), do: name

  defp normalize_name(name) when is_binary(name) do
    String.downcase(name) |> String.to_atom()
  end

  defp plant("V"), do: :violets
  defp plant("R"), do: :radishes
  defp plant("G"), do: :grass
  defp plant("C"), do: :clover
end
