defmodule Tree.Binary do
  defstruct content: nil, left: nil, right: nil

  def empty?(%__MODULE__{left: nil, right: nil}),do: true
  def empty?(%__MODULE__{}),do: false

  def new(value \\ nil) do
    %__MODULE__{content: value}
  end

  @doc """
  Converts a tuple tree to a Tree.Binary struct.

  A 'tuple tree' contains of (nested) triples.

  - The first element of the triple is the left hand side tree
  - the second element of the triple is the current node's value
  - the third element of the triple is the right hand side tree.

  - `{}` or `nil` is treated as an empty tree.
  """
  def fron_tuple_tree(tuple_tree)
  def from_tuple_tree({}), do: new()
  def from_tuple_tree(nil), do: new()
  def from_tuple_tree({left, content, right}) do
    %__MODULE__{left: left, content: content, right: right}
  end
end
