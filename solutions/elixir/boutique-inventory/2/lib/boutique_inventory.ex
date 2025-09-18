defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort_by(inventory, & &1.price)
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, &is_nil(&1.price))
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn element ->
      updated_name = String.replace(element.name, old_word, new_word)
      %{element | name: updated_name}
    end)
  end

  def increase_quantity(%{quantity_by_size: quantity} = item, count) do
    updated_quantity = Map.new(quantity, fn {size, qty} -> {size, qty + count} end)

    %{item | quantity_by_size: updated_quantity}
  end

  def total_quantity(item) do
    Enum.reduce(item.quantity_by_size, 0, fn {_key, value}, acc ->
      acc + value
    end)
  end
end
