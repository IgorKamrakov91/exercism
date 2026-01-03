defmodule StateOfTicTacToe do
  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    x_count = count(?X, board)
    o_count = count(?O, board)
    x_won? = win?(?X, board)
    o_won? = win?(?O, board)

    cond do
      o_count > x_count ->
        {:error, "Wrong turn order: O started"}

      x_count >= o_count + 2 ->
        {:error, "Wrong turn order: X went twice"}

      x_won? and o_won? ->
        {:error, "Impossible board: game should have ended after the game was won"}

      x_won? or o_won? ->
        {:ok, :win}

      x_count + o_count == 9 ->
        {:ok, :draw}

      true ->
        {:ok, :ongoing}
    end
  end

  defp count(_p, <<>>), do: 0
  defp count(p, <<p, rest::binary>>), do: 1 + count(p, rest)
  defp count(p, <<_, rest::binary>>), do: 0 + count(p, rest)

  defp win?(p, <<p, p, p, "\n", _, _, _, "\n", _, _, _, "\n">>), do: true
  defp win?(p, <<_, _, _, "\n", p, p, p, "\n", _, _, _, "\n">>), do: true
  defp win?(p, <<_, _, _, "\n", _, _, _, "\n", p, p, p, "\n">>), do: true
  defp win?(p, <<p, _, _, "\n", p, _, _, "\n", p, _, _, "\n">>), do: true
  defp win?(p, <<_, p, _, "\n", _, p, _, "\n", _, p, _, "\n">>), do: true
  defp win?(p, <<_, _, p, "\n", _, _, p, "\n", _, _, p, "\n">>), do: true
  defp win?(p, <<p, _, _, "\n", _, p, _, "\n", _, _, p, "\n">>), do: true
  defp win?(p, <<_, _, p, "\n", _, p, _, "\n", p, _, _, "\n">>), do: true
  defp win?(_p, _), do: false
end
