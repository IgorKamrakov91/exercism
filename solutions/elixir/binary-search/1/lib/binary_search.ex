defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    do_search(numbers, key, 0, tuple_size(numbers) - 1)
  end

  defp do_search(_tuple, _key, low, high) when low > high, do: :not_found

  defp do_search(tuple, key, low, high) do
    mid = div(low + high, 2)
    mid_value = elem(tuple, mid)

    cond do
      mid_value == key ->
        {:ok, mid}

      mid_value > key ->
        do_search(tuple, key, low, mid - 1)

      true ->
        do_search(tuple, key, mid + 1, high)
    end
  end
end
