defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @default_students [
    :alice,
    :bob,
    :charlie,
    :david,
    :eve,
    :fred,
    :ginny,
    :harriet,
    :ileana,
    :joseph,
    :kincaid,
    :larry
  ]

  @spec info(String.t()) :: map
  def info(info_string) do
    info(info_string, @default_students)
  end

  @spec info(String.t(), list) :: map
  def info(info_string, student_names) do
    {row1, row2} = parse_rows(info_string)

    sorted_students =
      student_names
      |> Enum.map(&normalize_name/1)
      |> Enum.sort()

    plant_groups =
      Enum.zip_with(
        Enum.chunk_every(row1, 2),
        Enum.chunk_every(row2, 2),
        &++/2
      )
      |> Stream.concat(Stream.cycle([[]]))

    Enum.zip(sorted_students, plant_groups)
    |> Map.new(fn {student, plants} ->
      {student, List.to_tuple(Enum.map(plants, &plant/1))}
    end)
  end

  defp parse_rows(info_string) do
    info_string
    |> String.split("\n", trim: true)
    |> case do
      [r1, r2] -> {String.graphemes(r1), String.graphemes(r2)}
      _ -> {[], []}
    end
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
