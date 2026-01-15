defmodule Pov do
  @typedoc """
  A tree, which is made of a node with several branches
  """
  @type tree :: {any, [tree]}

  @doc """
  Reparent a tree on a selected node.
  """
  @spec from_pov(tree :: tree, node :: any) :: {:ok, tree} | {:error, atom}
  def from_pov(tree, node) do
    with {sub_tree, visited} <- traverse(tree, node) do
      {:ok, reparent(visited, sub_tree)}
    else
      _ -> {:error, :nonexistent_target}
    end
  end

  defp traverse(tree, target, visited \\ [])

  defp traverse({target, _} = tree, target, visited) do
    {tree, visited}
  end

  defp traverse({node, tree}, target, visited) do
    Enum.find_value(tree, fn sub_node ->
      traverse(sub_node, target, [{node, tree} | visited])
    end)
  end

  defp reparent(visited, tree)
  defp reparent([], tree), do: tree

  defp reparent([{parent_node, parent_tree} | tl], {node, tree}) do
    {parent_node, List.keydelete(parent_tree, node, 0)}
    |> then(&{node, [reparent(tl, &1) | tree]})
  end

  @doc """
  Finds a path between two nodes
  """
  @spec path_between(tree :: tree, from :: any, to :: any) :: {:ok, [any]} | {:error, atom}
  def path_between(tree, from, to) do
    with from_pov <- from_pov(tree, from),
         {:ok, pov_tree} <- validate_source(from_pov),
         path <- path(pov_tree, to),
         :ok <- validate_destination(path) do
      {:ok, path}
    end
  end

  defp validate_source({:error, _}), do: {:error, :nonexistent_source}
  defp validate_source({:ok, pov_tree}), do: {:ok, pov_tree}

  defp validate_destination(path) do
    if Enum.empty?(path) do
      {:error, :nonexistent_destination}
    else
      :ok
    end
  end

  defp path(tree, target, visited \\ [])

  defp path({target, _}, target, visited) do
    Enum.reverse([target | visited])
  end

  defp path({node, tree}, target, visited) do
    Enum.find_value(tree, [], fn sub_node ->
      case path(sub_node, target, [node | visited]) do
        [] -> nil
        found_path -> found_path
      end
    end)
  end
end
