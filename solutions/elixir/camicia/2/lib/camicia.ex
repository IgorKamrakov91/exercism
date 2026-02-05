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
    %{
      deck_a: player_a,
      deck_b: player_b,
      pile: [],
      turn: :player_a,
      penalty: 0,
      last_payment_player: nil,
      cards: 0,
      tricks: 0,
      seen: MapSet.new()
    }
    |> do_simulate()
  end

  defp do_simulate(%{pile: []} = state) do
    state_key = {canonical(state.deck_a), canonical(state.deck_b), state.turn}

    if MapSet.member?(state.seen, state_key) do
      {:loop, state.cards, state.tricks}
    else
      %{state | seen: MapSet.put(state.seen, state_key)} |> step()
    end
  end

  defp do_simulate(state), do: step(state)

  defp step(state) do
    current = state.turn

    other = if current == :player_a, do: :player_b, else: :player_a

    deck = if current == :player_a, do: state.deck_a, else: state.deck_b

    case deck do
      [] ->
        if state.pile == [] do
          {:finished, state.cards, state.tricks}
        else
          collect(state, other)
        end

      [card | rest] ->
        state = %{state | cards: state.cards + 1, pile: [card | state.pile]}

        state =
          if current == :player_a, do: %{state | deck_a: rest}, else: %{state | deck_b: rest}

        case penalty_value(card) do
          0 ->
            cond do
              state.penalty > 0 ->
                if state.penalty == 1 do
                  collect(state, state.last_payment_player)
                else
                  do_simulate(%{state | penalty: state.penalty - 1})
                end

              true ->
                do_simulate(%{state | turn: other})
            end

          v ->
            do_simulate(%{state | turn: other, penalty: v, last_payment_player: current})
        end
    end
  end

  defp collect(state, winner) do
    new_tricks = state.tricks + 1

    pile_to_add = Enum.reverse(state.pile)

    state =
      if winner == :player_a do
        %{
          state
          | deck_a: state.deck_a ++ pile_to_add,
            tricks: new_tricks,
            pile: [],
            turn: :player_a,
            penalty: 0,
            last_payment_player: nil
        }
      else
        %{
          state
          | deck_b: state.deck_b ++ pile_to_add,
            tricks: new_tricks,
            pile: [],
            turn: :player_b,
            penalty: 0,
            last_payment_player: nil
        }
      end

    if state.deck_a == [] or state.deck_b == [] do
      {:finished, state.cards, state.tricks}
    else
      do_simulate(state)
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
