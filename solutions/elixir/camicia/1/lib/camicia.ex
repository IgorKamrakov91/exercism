defmodule Camicia do
  @doc """
    Simulate a card game between two players.
    Each player has a deck of cards represented as a list of strings.
    Returns a tuple with the result of the game:
    - `{:finished, cards, tricks}` if the game finishes with a winner
    - `{:loop, cards, tricks}` if the game enters a loop
    `cards` is the number of cards played.
    `tricks` is the number of central piles collected.

    ## Examples

      iex> Camicia.simulate(["2"], ["3"])
      {:finished, 2, 1}

      iex> Camicia.simulate(["J", "2", "3"], ["4", "J", "5"])
      {:loop, 8, 3}
  """

  @spec simulate(list(String.t()), list(String.t())) ::
          {:finished | :loop, non_neg_integer(), non_neg_integer()}
  def simulate(player_a, player_b) do
    do_simulate(player_a, player_b, [], :player_a, 0, nil, 0, 0, MapSet.new())
  end

  defp do_simulate(deck_a, deck_b, pile, turn, penalty, last_payment_player, cards, tricks, seen) do
    if pile == [] do
      state = {canonical(deck_a), canonical(deck_b), turn}

      if MapSet.member?(seen, state) do
        {:loop, cards, tricks}
      else
        new_seen = MapSet.put(seen, state)
        step(deck_a, deck_b, pile, turn, penalty, last_payment_player, cards, tricks, new_seen)
      end
    else
      step(deck_a, deck_b, pile, turn, penalty, last_payment_player, cards, tricks, seen)
    end
  end

  defp step(deck_a, deck_b, pile, :player_a, penalty, last_payment_player, cards, tricks, seen) do
    case deck_a do
      [] ->
        if pile == [] do
          {:finished, cards, tricks}
        else
          collect(:player_b, deck_a, deck_b, pile, cards, tricks + 1, seen)
        end

      [card | rest] ->
        new_pile = [card | pile]
        new_cards = cards + 1

        case penalty_value(card) do
          0 ->
            cond do
              penalty > 0 ->
                if penalty == 1 do
                  collect(
                    last_payment_player,
                    rest,
                    deck_b,
                    new_pile,
                    new_cards,
                    tricks + 1,
                    seen
                  )
                else
                  do_simulate(
                    rest,
                    deck_b,
                    new_pile,
                    :player_a,
                    penalty - 1,
                    last_payment_player,
                    new_cards,
                    tricks,
                    seen
                  )
                end

              true ->
                do_simulate(rest, deck_b, new_pile, :player_b, 0, nil, new_cards, tricks, seen)
            end

          v ->
            do_simulate(rest, deck_b, new_pile, :player_b, v, :player_a, new_cards, tricks, seen)
        end
    end
  end

  defp step(deck_a, deck_b, pile, :player_b, penalty, last_payment_player, cards, tricks, seen) do
    case deck_b do
      [] ->
        if pile == [] do
          {:finished, cards, tricks}
        else
          collect(:player_a, deck_a, deck_b, pile, cards, tricks + 1, seen)
        end

      [card | rest] ->
        new_pile = [card | pile]
        new_cards = cards + 1

        case penalty_value(card) do
          0 ->
            cond do
              penalty > 0 ->
                if penalty == 1 do
                  collect(
                    last_payment_player,
                    deck_a,
                    rest,
                    new_pile,
                    new_cards,
                    tricks + 1,
                    seen
                  )
                else
                  do_simulate(
                    deck_a,
                    rest,
                    new_pile,
                    :player_b,
                    penalty - 1,
                    last_payment_player,
                    new_cards,
                    tricks,
                    seen
                  )
                end

              true ->
                do_simulate(deck_a, rest, new_pile, :player_a, 0, nil, new_cards, tricks, seen)
            end

          v ->
            do_simulate(deck_a, rest, new_pile, :player_a, v, :player_b, new_cards, tricks, seen)
        end
    end
  end

  defp collect(:player_a, deck_a, deck_b, pile, cards, tricks, seen) do
    new_deck_a = deck_a ++ Enum.reverse(pile)

    if deck_b == [] do
      {:finished, cards, tricks}
    else
      do_simulate(new_deck_a, deck_b, [], :player_a, 0, nil, cards, tricks, seen)
    end
  end

  defp collect(:player_b, deck_a, deck_b, pile, cards, tricks, seen) do
    new_deck_b = deck_b ++ Enum.reverse(pile)

    if deck_a == [] do
      {:finished, cards, tricks}
    else
      do_simulate(deck_a, new_deck_b, [], :player_b, 0, nil, cards, tricks, seen)
    end
  end

  defp penalty_value("J"), do: 1
  defp penalty_value("Q"), do: 2
  defp penalty_value("K"), do: 3
  defp penalty_value("A"), do: 4
  defp penalty_value(_), do: 0

  defp canonical(deck) do
    Enum.map(deck, fn
      card when card in ["J", "Q", "K", "A"] -> card
      _ -> "N"
    end)
  end
end
