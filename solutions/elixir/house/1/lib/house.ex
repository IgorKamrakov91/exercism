defmodule House do
  @pieces [
    {"house that Jack built", nil},
    {"malt", "lay in"},
    {"rat", "ate"},
    {"cat", "killed"},
    {"dog", "worried"},
    {"cow with the crumpled horn", "tossed"},
    {"maiden all forlorn", "milked"},
    {"man all tattered and torn", "kissed"},
    {"priest all shaven and shorn", "married"},
    {"rooster that crowed in the morn", "woke"},
    {"farmer sowing his corn", "kept"},
    {"horse and the hound and the horn", "belonged to"}
  ]

  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    Enum.map_join(start..stop, "", &verse/1)
  end

  defp verse(number) do
    "This is " <> main_phrase(number) <> ".\n"
  end

  defp main_phrase(number) do
    @pieces
    |> Enum.take(number)
    |> Enum.reverse()
    |> Enum.map_join(" ", &phrase/1)
  end

  defp phrase({object, nil}), do: "the #{object}"
  defp phrase({object, verb}), do: "the #{object} that #{verb}"
end
