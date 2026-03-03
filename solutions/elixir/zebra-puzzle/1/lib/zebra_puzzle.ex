defmodule ZebraPuzzle do
  @colors [:red, :green, :ivory, :yellow, :blue]
  @nationalities [:englishman, :spaniard, :ukrainian, :norwegian, :japanese]
  @pets [:dog, :snails, :fox, :horse, :zebra]
  @drinks [:coffee, :tea, :milk, :orange_juice, :water]
  @hobbies [:dancing, :painter, :reading, :football, :chess]

  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water() do
    [{water_drinker, _}] = solve()
    water_drinker
  end

  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra() do
    [{_, zebra_owner}] = solve()
    zebra_owner
  end

  defp solve() do
    for nationalities <- permutations(@nationalities),
        # 10. The Norwegian lives in the first house.
        hd(nationalities) == :norwegian,
        colors <- permutations(@colors),
        # 15. The Norwegian lives next to the blue house.
        next_to?(nationalities, :norwegian, colors, :blue),
        # 6. The green house is immediately to the right of the ivory house.
        right_of?(colors, :green, :ivory),
        # 2. The Englishman lives in the red house.
        same_index?(nationalities, :englishman, colors, :red),
        drinks <- permutations(@drinks),
        # 9. The person in the middle house drinks milk.
        Enum.at(drinks, 2) == :milk,
        # 4. The person in the green house drinks coffee.
        same_index?(colors, :green, drinks, :coffee),
        # 5. The Ukrainian drinks tea.
        same_index?(nationalities, :ukrainian, drinks, :tea),
        hobbies <- permutations(@hobbies),
        # 8. The person in the yellow house is a painter.
        same_index?(colors, :yellow, hobbies, :painter),
        # 13. The person who plays football drinks orange juice.
        same_index?(hobbies, :football, drinks, :orange_juice),
        # 14. The Japanese person plays chess.
        same_index?(nationalities, :japanese, hobbies, :chess),
        pets <- permutations(@pets),
        # 3. The Spaniard owns the dog.
        same_index?(nationalities, :spaniard, pets, :dog),
        # 7. The snail owner likes to go dancing.
        same_index?(pets, :snails, hobbies, :dancing),
        # 11. The person who enjoys reading lives in the house next to the person with the fox.
        next_to?(hobbies, :reading, pets, :fox),
        # 12. The painter's house is next to the house with the horse.
        next_to?(hobbies, :painter, pets, :horse) do
      water_index = Enum.find_index(drinks, &(&1 == :water))
      zebra_index = Enum.find_index(pets, &(&1 == :zebra))

      {Enum.at(nationalities, water_index), Enum.at(nationalities, zebra_index)}
    end
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for elem <- list,
        rest <- permutations(list -- [elem]),
        do: [elem | rest]
  end

  defp same_index?(list1, val1, list2, val2) do
    Enum.find_index(list1, &(&1 == val1)) == Enum.find_index(list2, &(&1 == val2))
  end

  defp right_of?(list, val1, val2) do
    Enum.find_index(list, &(&1 == val1)) == Enum.find_index(list, &(&1 == val2)) + 1
  end

  defp next_to?(list1, val1, list2, val2) do
    idx1 = Enum.find_index(list1, &(&1 == val1))
    idx2 = Enum.find_index(list2, &(&1 == val2))
    abs(idx1 - idx2) == 1
  end
end
