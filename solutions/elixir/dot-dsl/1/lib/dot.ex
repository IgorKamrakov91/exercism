defmodule Dot do
  defmacro graph(do: block) do
    lines =
      case block do
        {:__block__, _, lines} -> lines
        line -> [line]
      end

    Enum.reduce(lines, Graph.new(), &process_line/2) |> Macro.escape()
  end

  defp process_line({:graph, _, [attrs]}, graph) do
    if Keyword.keyword?(attrs) do
      Graph.put_attrs(graph, attrs)
    else
      raise ArgumentError
    end
  end

  defp process_line({node, _, atom}, graph) when is_atom(atom) do
    if not is_atom(node), do: raise(ArgumentError)
    Graph.add_node(graph, node, [])
  end

  defp process_line({node, _, [attrs]}, graph) do
    if is_atom(node) and Keyword.keyword?(attrs) do
      Graph.add_node(graph, node, attrs)
    else
      raise ArgumentError
    end
  end

  defp process_line({:--, _, [{node1, _, _}, {node2, _, attrs}]}, graph) do
    if not is_atom(node1) or not is_atom(node2) do
      raise ArgumentError
    end

    case attrs do
      [attrs] ->
        if Keyword.keyword?(attrs) do
          Graph.add_edge(graph, node1, node2, attrs)
        else
          raise ArgumentError
        end

      nil ->
        Graph.add_edge(graph, node1, node2, [])

      _ ->
        raise ArgumentError
    end
  end

  defp process_line(_, _) do
    raise ArgumentError
  end
end
