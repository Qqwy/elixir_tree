defmodule Tree.Rose do
  @moduledoc """
  A rose tree, a tree where each node
  can have many children.

  For access speed, the children are put in a map (an integer indexed array).
  """
  defstruct content: nil, children: %{}, num_children: 0

  @doc """
  True if the tree is empty.
  """
  def empty?(%__MODULE__{content: nil, children: %{}, num_children: 0}), do: true
  def empty?(%__MODULE__{}), do: false

  @doc """
  True if this node does not have any children.
  """
  def leaf?(%__MODULE__{children: %{}, num_children: 0}), do: true
  def leaf?(%__MODULE__{}), do: false

  @doc """
  Creates a tree with a single value.

  If no value is specified, `nil` is used (this represents an empty tree.)
  """
  def new(value \\ nil) do
    %__MODULE__{content: value, children: %{}, num_children: 0}
  end

  @doc """
  Adds a child to the given node.
  """
  def add_child(node = %__MODULE__{children: children, num_children: num_children}, child_content) do
    new_children = Map.put(children, num_children, %{content: child_content, children: %{}})
    %__MODULE__{node|children: new_children, num_children: num_children + 1}
  end

  # def add_parent(children, parent_content) when is_list(children) do
  #   children_map = for {child, index} <- Enum.with_index(children), do: {index, child}, into: %{}
  #   %__MODULE__{children: children_map, content: parent_content}
  # end


  def add_parent(children, parent_content) when is_map(children) do
    %__MODULE__{content: parent_content, children: children}
  end

  @doc """
  A format in which every node is the first element of a tuple,
  and the second element is a list of tuples.
  """
  def from_nested_tuple_list({content, children}) do
    {children, num_children} = Enum.map_reduce(children, 0, &do_from_nested_tuple_list/2)
    children_map = Enum.into(children, %{})
    %__MODULE__{content: content, children: children_map, num_children: num_children}
  end

  defp do_from_nested_tuple_list({content, children}, acc) do
    {children, num_children} = Enum.map_reduce(children, 0, &do_from_nested_tuple_list/2)
    children_map = Enum.into(children, %{})
    {{acc, %{content: content, children: children_map, num_children: num_children}}, acc + 1}
  end


  # The access protocol works on the children.
  @behaviour Access
  def fetch(%__MODULE__{children: children}, key) do
    case Map.fetch(children, key) do
      {:ok, %{content: content, children: children}} -> {:ok, %__MODULE__{content: content, children: children }}
      :error -> :error
    end
  end

  def get(%__MODULE__{children: children}, key, default \\ nil) do
    case Map.get(children, key, default) do
      ^default -> default
      %{content: content, children: children} -> %__MODULE__{content: content, children: children}
    end
  end

  def get_and_update(tree = %__MODULE__{children: children}, key, fun) do
    {value, new_children} = Map.get_and_update(children, key, fn %{content: content, children: found_children} ->
      case fun.(content) do
        :pop -> :pop
        {value, new_content} -> {value, %{children: found_children, content: new_content}}

      end
    end)
    {value, %__MODULE__{tree | children: new_children}}
  end

  def pop(tree = %__MODULE__{children: children}, key) do
    {value, new_children} = Map.pop(children, key)
    {value, %__MODULE__{tree | children: new_children}}
  end
end
