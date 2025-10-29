defmodule Poker do
  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    hand_scores = Enum.map(hands, fn hand -> {hand, evaluate_hand(hand)} end)
    best_score = hand_scores |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for {hand, score} <- hand_scores, score == best_score, do: hand
  end

  # Evaluate the hand and return a value to compare hands by poker rules
  defp evaluate_hand(hand) do
    {ranks, suits} = Enum.unzip(Enum.map(hand, &parse_card/1))
    sorted_ranks_desc = Enum.sort(ranks, :desc)
    is_flush = Enum.uniq(suits) |> length() == 1
    straight_high_card = detect_straight_high_card(ranks)
    rank_frequencies = Enum.frequencies(ranks)

    # Group ranks by their count (e.g. pairs, triplets, etc.)
    grouped_by_count =
      Enum.group_by(rank_frequencies, fn {_, count} -> count end, fn {rank, _} -> rank end)

    # Build map of count -> sorted list of ranks for tie breaking
    count_map =
      for count <- [4, 3, 2, 1], into: %{} do
        ranks_group = Map.get(grouped_by_count, count, []) |> Enum.sort(:desc)
        {count, ranks_group}
      end

    counts_sorted_desc = rank_frequencies |> Map.values() |> Enum.sort(:desc)

    hand_rank_tuple(
      is_flush,
      straight_high_card,
      counts_sorted_desc,
      count_map,
      sorted_ranks_desc
    )
  end

  # Determines hand ranking in form {category_rank, tie_breaker_list}
  # Straight Flush
  defp hand_rank_tuple(true, high, _, _, _) when is_integer(high), do: {8, [high]}
  # Four of a Kind
  defp hand_rank_tuple(_, _, [4, 1], groups, _), do: {7, [hd(groups[4]), hd(groups[1])]}
  # Full House
  defp hand_rank_tuple(_, _, [3, 2], groups, _), do: {6, [hd(groups[3]), hd(groups[2])]}
  # Flush
  defp hand_rank_tuple(true, nil, [1, 1, 1, 1, 1], _, sorted), do: {5, sorted}
  # Straight
  defp hand_rank_tuple(_, high, [1, 1, 1, 1, 1], _, _) when is_integer(high), do: {4, [high]}
  # Three of a Kind
  defp hand_rank_tuple(_, _, [3, 1, 1], groups, _), do: {3, [hd(groups[3]) | groups[1]]}
  # Two Pair
  defp hand_rank_tuple(_, _, [2, 2, 1], groups, _), do: {2, groups[2] ++ [hd(groups[1])]}
  # One Pair
  defp hand_rank_tuple(_, _, [2, 1, 1, 1], groups, _), do: {1, [hd(groups[2]) | groups[1]]}
  # High Card
  defp hand_rank_tuple(_, _, [1, 1, 1, 1, 1], _, sorted), do: {0, sorted}

  defp parse_card(card) do
    {rank_str, suit} = String.split_at(card, String.length(card) - 1)
    {parse_rank(rank_str), suit}
  end

  defp parse_rank("J"), do: 11
  defp parse_rank("Q"), do: 12
  defp parse_rank("K"), do: 13
  defp parse_rank("A"), do: 14
  defp parse_rank(numeric), do: String.to_integer(numeric)

  defp detect_straight_high_card(ranks) do
    uniq_ranks = Enum.uniq(ranks)
    if length(uniq_ranks) != 5, do: nil, else: straight_high_in_five(uniq_ranks)
  end

  defp straight_high_in_five(ranks) do
    sorted = Enum.sort(ranks)

    cond do
      consecutive?(sorted) ->
        List.last(sorted)

      true ->
        # Try ace-low straight: replace 14 with 1 and check again
        ace_low_sorted =
          sorted
          |> Enum.map(fn card -> if card == 14, do: 1, else: card end)
          |> Enum.sort()

        if consecutive?(ace_low_sorted),
          do: List.last(ace_low_sorted),
          else: nil
    end
  end

  defp consecutive?([a, b, c, d, e]) do
    [b - a, c - b, d - c, e - d] == [1, 1, 1, 1]
  end
end
