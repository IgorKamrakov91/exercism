defmodule Zipper do
  @moduledoc """
  A zipper for binary trees.
  """

  defstruct [:focus, :crumbs]

  @type crumb :: {:left, any, BinTree.t() | nil} | {:right, any, BinTree.t() | nil}
  @type t :: %Zipper{focus: BinTree.t() | nil, crumbs: [crumb]}

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{focus: bin_tree, crumbs: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(zipper) do
    case up(zipper) do
      nil -> zipper.focus
      parent_zipper -> to_tree(parent_zipper)
    end
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{focus: focus}) do
    focus.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{focus: %BinTree{left: nil}}), do: nil

  def left(%Zipper{focus: %BinTree{value: value, left: left, right: right}, crumbs: crumbs}) do
    %Zipper{
      focus: left,
      crumbs: [{:left, value, right} | crumbs]
    }
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{focus: %BinTree{right: nil}}), do: nil

  def right(%Zipper{focus: %BinTree{value: value, left: left, right: right}, crumbs: crumbs}) do
    %Zipper{
      focus: right,
      crumbs: [{:right, value, left} | crumbs]
    }
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{crumbs: []}), do: nil

  def up(%Zipper{focus: focus, crumbs: [{:left, parent_value, right_sibling} | rest]}) do
    %Zipper{
      focus: %BinTree{value: parent_value, left: focus, right: right_sibling},
      crumbs: rest
    }
  end

  def up(%Zipper{focus: focus, crumbs: [{:right, parent_value, left_sibling} | rest]}) do
    %Zipper{
      focus: %BinTree{value: parent_value, left: left_sibling, right: focus},
      crumbs: rest
    }
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%Zipper{focus: %BinTree{} = focus} = zipper, value) do
    %Zipper{zipper | focus: %BinTree{focus | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%Zipper{focus: %BinTree{} = focus} = zipper, left) do
    %Zipper{zipper | focus: %BinTree{focus | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%Zipper{focus: %BinTree{} = focus} = zipper, right) do
    %Zipper{zipper | focus: %BinTree{focus | right: right}}
  end
end
