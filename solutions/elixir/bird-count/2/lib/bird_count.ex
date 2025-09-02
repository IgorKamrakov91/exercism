defmodule BirdCount do
  def today([]), do: nil
  def today([head | _tail]) do
    head
  end

  def increment_day_count([]), do: [1]
  def increment_day_count([head | tail]) do
    [head + 1 | tail]
  end

  def has_day_without_birds?([]), do: false 
  def has_day_without_birds?([head | _tail]) when head == 0, do: true
  def has_day_without_birds?([_head | tail]), do: has_day_without_birds?(tail) 

  
  def total([head | tail], data \\ 0), do: total(tail, head + data)
  def total([], data), do: data

  def busy_days([head | tail], data \\ 0) do
    updated_data = if head > 4, do: data + 1, else: data
    busy_days(tail, updated_data)
  end
  def busy_days([], data), do: data
end
