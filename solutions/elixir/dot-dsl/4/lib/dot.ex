defmodule Dot do
  @moduledoc """
  A Domain Specific Language (DSL) for creating Graph structures.

  This module provides a macro that allows defining graphs using a syntax
  similar to the DOT graph description language.

  ## Examples

      Dot.graph do
        graph(title: "My Graph")
        a(color: :red)
        b(color: :blue)
        a -- b(weight: 1)
      end
  """

  @doc """
  Creates a Graph structure using the DOT-like DSL.

  Supports:
  - Graph attributes: `graph(key: value)`
  - Nodes: `a` or `a(color: :green)`
  - Edges: `a -- b` or `a -- b(weight: 1)`

  Raises `ArgumentError` for invalid syntax.
  """
  defmacro graph(do: ast) do
    ast
    |> process_ast(Graph.new())
    |> Macro.escape()
  end

  # Empty block
  defp process_ast(nil, graph), do: graph

  # Multiple statements (block)
  defp process_ast({:__block__, _meta, statements}, graph) do
    Enum.reduce(statements, graph, &process_statement/2)
  end

  # Single statement (not a block)
  defp process_ast(statement, graph) do
    process_statement(statement, graph)
  end

  # Graph attribute: graph(foo: 1)
  defp process_statement({:graph, _meta, [attrs]}, graph) when is_list(attrs) do
    Graph.put_attrs(graph, attrs)
  end

  # Edge: a -- b
  defp process_statement({:--, _meta, [{from, _, nil}, {to, _, nil}]}, graph)
       when is_atom(from) and is_atom(to) do
    Graph.add_edge(graph, from, to)
  end

  # Edge with attributes: a -- b(color: :blue)
  defp process_statement({:--, _meta, [{from, _, nil}, {to, _, [attrs]}]}, graph)
       when is_atom(from) and is_atom(to) and is_list(attrs) do
    Graph.add_edge(graph, from, to, attrs)
  end

  # Node with no attributes: a
  defp process_statement({name, _meta, nil}, graph) when is_atom(name) do
    Graph.add_node(graph, name)
  end

  # Node with keyword attributes: a(color: :green)
  defp process_statement({name, _meta, [attrs]}, graph)
       when is_atom(name) and is_list(attrs) do
    Graph.add_node(graph, name, attrs)
  end

  # Invalid syntax - catch all
  defp process_statement(_ast, _graph) do
    raise ArgumentError
  end
end
