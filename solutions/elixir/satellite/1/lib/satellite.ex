defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree(preorder, inorder) do
    cond do
      length(preorder) != length(inorder) ->
        {:error, "traversals must have the same length"}

      Enum.uniq(preorder) != preorder ->
        {:error, "traversals must contain unique items"}

      Enum.sort(preorder) != Enum.sort(inorder) ->
        {:error, "traversals must have the same elements"}

      true ->
        {:ok, do_build_tree(preorder, inorder)}
    end
  end

  defp do_build_tree([], []), do: {}

  defp do_build_tree([root | rest_preorder], inorder) do
    {left_inorder, [_root | right_inorder]} = Enum.split_while(inorder, fn x -> x != root end)

    left_size = length(left_inorder)
    {left_preorder, right_preorder} = Enum.split(rest_preorder, left_size)

    {
      do_build_tree(left_preorder, left_inorder),
      root,
      do_build_tree(right_preorder, right_inorder)
    }
  end
end
