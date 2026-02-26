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

defmodule Graph do
  @moduledoc """
  A minimal implementation of a Graph, comprising
  of some nodes and edges between them.
  Nodes, edges and the graph itself may have
  attributes.
  """
  defstruct attrs: %{}, nodes: %{}, edges: []
  @type id :: atom
  @type vertex :: {id, map}
  @type edge :: {id, id, map}
  @type t :: %Graph{
          attrs: map,
          nodes: %{id => keyword},
          edges: [edge]
        }
  @type attrs :: map | keyword

  @doc """
  Returns a new empty graph
  """
  @spec new() :: t
  def new(), do: %Graph{}

  @doc """
  Sets attributes for the graph
  """
  @spec put_attrs(t, attrs) :: t
  def put_attrs(%Graph{} = g, attrs) do
    %{g | attrs: Enum.into(attrs, g.attrs)}
  end

  @doc """
  Add the node to the graph, with optional attributes.
  If the node was already present, simply merges the attributes.
  """
  @spec add_node(t, id, attrs) :: t
  def add_node(%Graph{} = g, id, attrs) do
    update_in(g.nodes[id], fn cur ->
      Enum.into(attrs, cur || %{})
    end)
  end

  def add_node(%Graph{} = g, id) do
    %{g | nodes: Map.put_new(g.nodes, id, %{})}
  end

  @doc """
  Adds an edge `from` -> `to` to the graph, with optional
  attributes. Both nodes will be automatically added if need be.
  Multiple edges between the same nodes may be added.
  """
  @spec add_edge(t, id, id, attrs) :: t
  def add_edge(%Graph{} = g, from, to, attrs \\ []) do
    edge = {from, to, Enum.into(attrs, %{})}
    %{(g |> add_node(from) |> add_node(to)) | edges: [edge | g.edges]}
  end

  @doc """
  Returns wether the two given graphs are equivalent or not
  """
  @spec equal?(t, t) :: boolean
  def equal?(%Graph{} = a, %Graph{} = b) do
    canonical(a) == canonical(b)
  end

  def equal?(%Graph{}, _other) do
    false
  end

  @doc """
  Returns an equivalent graph in a canonical form
  """
  @spec canonical(t) :: t
  def canonical(%Graph{} = g) do
    %{g | edges: g.edges |> Enum.sort()}
  end
end
