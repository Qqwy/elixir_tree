defmodule Tree.Rose do
  @moduledoc """
  A rose tree, a tree where each node
  can have many children.

  For access speed, the children are put in a map (an integer indexed array).
  """

  defstruct content: %{}, num_nodes: 0

  @node_map %{node: %{}, children: %{}, num_children: 0}

  @doc """
  Creates a new, blank tree.
  """
  def empty do
    %__MODULE__{}
  end

  @doc """
  True if the tree is empty.
  """
  def empty?(%__MODULE__{content: %{}}), do: true
  def empty?(%__MODULE__{}), do: false

  @doc """
  Creates a tree with a single value.
  """
  def singleton(value) do
    node = Map.put(@node_map, :node, value)
    %__MODULE__{content: node, num_nodes: 1}
  end


  @doc """
  Adds a child to the given node.

  TODO this is only an internal function.
  """
  def add_child(_node = %{children: children, num_children: num_children}, child) do
    child_node = Map.put(@node_map, :node, child)
    %{children: %{children| num_children => child_node}, num_children: num_children+1}
  end



end
