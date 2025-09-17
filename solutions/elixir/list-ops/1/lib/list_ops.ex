defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count(l), do: count(l, 0)
  def count([], acc), do: acc

  def count([_head | rest], acc) do
    count(rest, acc + 1)
  end

  @spec reverse(list) :: list
  def reverse([]), do: []
  def reverse(list), do: reverse(list, [])
  def reverse([], result), do: result

  def reverse([head | rest], res) do
    reverse(rest, [head | res])
  end

  @spec map(list, (any -> any)) :: list
  def map([], _), do: []
  def map(list, fun), do: map(list, fun, [])
  def map([], _fun, acc), do: acc |> reverse()

  def map([head | rest], fun, acc) do
    map(rest, fun, [fun.(head) | acc])
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], _function), do: []
  def filter(list, function), do: filter(list, function, [])
  def filter([], _function, result), do: result |> reverse()

  def filter([head | rest], function, result) do
    if function.(head) do
      filter(rest, function, [head | result])
    else
      filter(rest, function, result)
    end
  end

  @type acc :: any

  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _f), do: acc

  def foldl([head | tail], acc, f) do
    foldl(tail, f.(head, acc), f)
  end

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr([], acc, _f), do: acc

  def foldr([head | tail], acc, f) do
    f.(head, foldr(tail, acc, f))
  end

  @spec append(list, list) :: list
  def append([], []), do: []
  def append([], list), do: list
  def append(list, []), do: list

  def append([head | tail], list_b) do
    [head | append(tail, list_b)]
  end

  @spec concat([[any]]) :: [any]
  def concat([]), do: []

  def concat([head | tail]) do
    append(head, concat(tail))
  end
end
