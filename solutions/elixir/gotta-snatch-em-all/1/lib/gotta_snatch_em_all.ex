defmodule GottaSnatchEmAll do
  @type card :: String.t()
  @type collection :: MapSet.t(card())

  @spec new_collection(card()) :: collection()
  def new_collection(card) do
    MapSet.new([card])
  end

  @spec add_card(card(), collection()) :: {boolean(), collection()}
  def add_card(card, collection) do
    already_exists = MapSet.member?(collection, card)
    {already_exists, MapSet.put(collection, card)}
  end

  @spec trade_card(card(), card(), collection()) :: {boolean(), collection()}
  def trade_card(your_card, their_card, collection) do
    has_your_card = MapSet.member?(collection, your_card)
    has_their_card = MapSet.member?(collection, their_card)

    can_trade = has_your_card and not has_their_card

    cond do
      can_trade ->
        {true,
         collection
         |> MapSet.delete(your_card)
         |> MapSet.put(their_card)}

      has_your_card and has_their_card ->
        {false,
         collection
         |> MapSet.delete(your_card)}

      true ->
        {false, MapSet.put(collection, their_card)}
    end
  end

  @spec remove_duplicates([card()]) :: [card()]
  def remove_duplicates(cards) do
    cards |> MapSet.new() |> MapSet.to_list() |> Enum.sort()
  end

  @spec extra_cards(collection(), collection()) :: non_neg_integer()
  def extra_cards(your_collection, their_collection) do
    your_collection |> MapSet.difference(their_collection) |> MapSet.size()
  end

  @spec boring_cards([collection()]) :: [card()]
  def boring_cards([]), do: []

  def boring_cards([first | rest]) do
    Enum.reduce(rest, first, &MapSet.intersection/2)
    |> MapSet.to_list()
    |> Enum.sort()
  end

  @spec total_cards([collection()]) :: non_neg_integer()
  def total_cards(collections) do
    collections |> Enum.reduce(MapSet.new(), &MapSet.union/2) |> MapSet.size()
  end

  @spec split_shiny_cards(collection()) :: {[card()], [card()]}
  def split_shiny_cards(collection) do
    {shiny, normal} =
      collection |> MapSet.to_list() |> Enum.split_with(&String.starts_with?(&1, "Shiny"))

    {Enum.sort(shiny), Enum.sort(normal)}
  end
end
