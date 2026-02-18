defmodule RelativeDistance do
  @doc """
  Find the degree of separation of two members given a given family tree.
  """
  @spec degree_of_separation(
          family_tree :: %{String.t() => [String.t()]},
          person_a :: String.t(),
          person_b :: String.t()
        ) :: nil | pos_integer()
  def degree_of_separation(family_tree, person_a, person_b) do
    graph = build_graph(family_tree)
    bfs(graph, person_a, person_b)
  end

  defp build_graph(family_tree) do
    Enum.reduce(family_tree, %{}, fn {parent, children}, acc ->
      acc
      |> add_parent_child_edges(parent, children)
      |> add_sibling_edges(children)
    end)
  end

  defp add_parent_child_edges(graph, parent, children) do
    Enum.reduce(children, graph, fn child, g ->
      g
      |> add_edge(parent, child)
      |> add_edge(child, parent)
    end)
  end

  defp add_sibling_edges(graph, children) do
    Enum.reduce(children, graph, fn c1, g1 ->
      Enum.reduce(children, g1, fn c2, g2 ->
        if c1 != c2 do
          add_edge(g2, c1, c2)
        else
          g2
        end
      end)
    end)
  end

  defp add_edge(graph, u, v) do
    Map.update(graph, u, MapSet.new([v]), &MapSet.put(&1, v))
  end

  defp bfs(graph, start, target) do
    if not Map.has_key?(graph, start) or not Map.has_key?(graph, target) do
      nil
    else
      queue = :queue.from_list([{start, 0}])
      visited = MapSet.new([start])
      do_bfs(queue, visited, graph, target)
    end
  end

  defp do_bfs(queue, visited, graph, target) do
    case :queue.out(queue) do
      {:empty, _} ->
        nil

      {{:value, {current, dist}}, rest_queue} ->
        if current == target do
          dist
        else
          neighbors = Map.get(graph, current, MapSet.new())

          {new_queue, new_visited} =
            Enum.reduce(neighbors, {rest_queue, visited}, fn neighbor, {q, v} ->
              if MapSet.member?(v, neighbor) do
                {q, v}
              else
                {:queue.in({neighbor, dist + 1}, q), MapSet.put(v, neighbor)}
              end
            end)

          do_bfs(new_queue, new_visited, graph, target)
        end
    end
  end
end