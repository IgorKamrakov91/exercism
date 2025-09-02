defmodule Username do
  def sanitize(username) do
    # ä becomes ae
    # ö becomes oe
    # ü becomes ue
    # ß becomes ss
    # Please implement the sanitize/1 function
    username
    |> Enum.flat_map(&substitute_non_latin_german/1)
    |> Enum.filter(&is_character_allowed/1)
  end
  defp is_character_allowed(c) when c in ?a..?z, do: true
  defp is_character_allowed(?_), do: true
  defp is_character_allowed(_), do: false
  def substitute_non_latin_german(c) do
    case c do
      ?ä -> 'ae'
      ?ö -> 'oe'
      ?ü -> 'ue'
      ?ß -> 'ss'
      c -> [c]
    end
  end
end