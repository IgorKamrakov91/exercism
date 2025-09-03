defmodule HighSchoolSweetheart do
  def first_letter(name) do
    String.trim(name) |> String.first()
  end

  def initial(name) do
    first_letter(name) |> String.upcase() |> Kernel.<>(".")
  end

  def initials(full_name) do
    [name, second_name] = String.split(full_name, " ")
    Enum.join([initial(name), initial(second_name)], " ")
  end

  def pair(full_name1, full_name2) do
    fi = initials(full_name1)
    si = initials(full_name2)

"     ******       ******\n   **      **   **      **\n **         ** **         **\n**            *            **\n**                         **\n**     #{fi}  +  #{si}     **\n **                       **\n   **                   **\n     **               **\n       **           **\n         **       **\n           **   **\n             ***\n              *\n"
  end
end
