defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    case list do
      [] ->
        []

      [head | tail] ->
        if fun.(head) do
          [head | keep(tail, fun)]
        else
          keep(tail, fun)
        end
    end
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    case list do
      [] ->
        []

      [head | tail] ->
        if fun.(head) do
          discard(tail, fun)
        else
          [head | discard(tail, fun)]
        end
    end
  end
end
