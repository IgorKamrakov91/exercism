defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @header "Team                           | MP |  W |  D |  L |  P"

  @spec tally(input :: list(String.t())) :: String.t()
  def tally([]), do: @header

  def tally(input) do
    stats =
      Enum.reduce(input, %{}, fn line, acc ->
        case parse_line(line) do
          {:ok, {team1, team2, :win}} ->
            acc |> ensure_team(team1) |> ensure_team(team2) |> win(team1, team2)

          {:ok, {team1, team2, :loss}} ->
            acc |> ensure_team(team1) |> ensure_team(team2) |> loss(team1, team2)

          {:ok, {team1, team2, :draw}} ->
            acc |> ensure_team(team1) |> ensure_team(team2) |> draw(team1, team2)

          :error ->
            acc
        end
      end)

    rows =
      stats
      |> Enum.to_list()
      |> Enum.sort_by(fn {name, s} -> {-s.p, name} end)
      |> Enum.map(&format_row/1)

    Enum.join([@header | rows], "\n")
  end

  defp parse_line(line) do
    case String.split(line, ";", parts: 3) do
      [team1, team2, result] ->
        case result do
          "win" -> {:ok, {team1, team2, :win}}
          "loss" -> {:ok, {team1, team2, :loss}}
          "draw" -> {:ok, {team1, team2, :draw}}
          _ -> :error
        end

      _ ->
        :error
    end
  end

  defp ensure_team(acc, team) do
    Map.update(acc, team, %{mp: 0, w: 0, d: 0, l: 0, p: 0}, & &1)
  end

  defp win(acc, w_team, l_team) do
    acc
    |> Map.update!(w_team, fn s -> %{s | mp: s.mp + 1, w: s.w + 1, p: s.p + 3} end)
    |> Map.update!(l_team, fn s -> %{s | mp: s.mp + 1, l: s.l + 1} end)
  end

  defp loss(acc, l_team, w_team) do
    win(acc, w_team, l_team)
  end

  defp draw(acc, team1, team2) do
    acc
    |> Map.update!(team1, fn s -> %{s | mp: s.mp + 1, d: s.d + 1, p: s.p + 1} end)
    |> Map.update!(team2, fn s -> %{s | mp: s.mp + 1, d: s.d + 1, p: s.p + 1} end)
  end

  defp format_row({name, s}) do
    team_width = @header |> String.split("|") |> hd() |> String.length()
    name_field = String.pad_trailing(name, team_width - 1)

    [
      name_field,
      " | ",
      pad2(s.mp),
      " | ",
      pad2(s.w),
      " | ",
      pad2(s.d),
      " | ",
      pad2(s.l),
      " | ",
      pad2(s.p)
    ]
    |> IO.iodata_to_binary()
  end

  defp pad2(int), do: int |> Integer.to_string() |> String.pad_leading(2)
end
