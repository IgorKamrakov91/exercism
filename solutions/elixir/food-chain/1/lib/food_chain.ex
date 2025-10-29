defmodule FoodChain do
  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @animals [
    {1, "fly"},
    {2, "spider"},
    {3, "bird"},
    {4, "cat"},
    {5, "dog"},
    {6, "goat"},
    {7, "cow"},
    {8, "horse"}
  ]

  @remarks %{
    "spider" => "It wriggled and jiggled and tickled inside her.",
    "bird" => "How absurd to swallow a bird!",
    "cat" => "Imagine that, to swallow a cat!",
    "dog" => "What a hog, to swallow a dog!",
    "goat" => "Just opened her throat and swallowed a goat!",
    "cow" => "I don't know how she swallowed a cow!",
    "horse" => "She's dead, of course!"
  }

  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    start..stop
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  defp verse(8) do
    [
      header("horse"),
      @remarks["horse"]
    ]
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp verse(n) when n >= 1 and n <= 7 do
    animal = animal(n)

    [header(animal)]
    |> add_remark(animal)
    |> add_chain(n)
    |> add_final()
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp header(animal), do: "I know an old lady who swallowed a #{animal}."

  defp add_remark(lines, "fly"), do: lines
  defp add_remark(lines, animal), do: lines ++ [@remarks[animal]]

  defp add_chain(lines, 1), do: lines
  defp add_chain(lines, n) do
    chain_lines =
      n..2
      |> Enum.map(fn i ->
        predator = animal(i)
        prey = animal(i - 1)
        "She swallowed the #{predator} to catch the #{prey}#{spider_suffix(prey, n)}."
      end)

    lines ++ chain_lines
  end

  defp spider_suffix("spider", verse_num) when verse_num >= 3,
    do: " that wriggled and jiggled and tickled inside her"

  defp spider_suffix(_, _), do: ""

  defp add_final(lines),
    do: lines ++ ["I don't know why she swallowed the fly. Perhaps she'll die."]

  defp animal(index) do
    Enum.find_value(@animals, fn {i, a} -> if i == index, do: a end)
  end
end
