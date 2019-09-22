defmodule SimpleXmlParser.Utils.TreeParser do
  @moduledoc """
  The module converts PureXmlParser result to Elixir data types
  """

  @doc ~S"""
  Convert the input list from PureXmlParser to a map

  ## Examples

      Parse an empty object
      iex> SimpleXmlParser.Utils.TreeParser.to_map({:return, [], []})
      %{return: nil}

      Parse a primitive:
      iex> SimpleXmlParser.Utils.TreeParser.to_map({:return, "Hello world", []})
      %{return: "Hello world"}

      Parse a single object
      iex> SimpleXmlParser.Utils.TreeParser.to_map({:return, [{:id, "1", []}, {:code, "example", []}], []})
      %{return: %{id: "1", code: "example"}}

      Parse a complex object
      iex> SimpleXmlParser.Utils.TreeParser.to_map({:return, [{:childs, [{:child, "1", []}], []}], []})
      %{return: %{childs: %{child: "1"}}}

      iex> SimpleXmlParser.Utils.TreeParser.to_map({:return, [{:childs, [{:child, "1", []}, {:child, "2", []}], []}], []})
      %{return: %{childs: %{child: ["1", "2"]}}}
  """
  @spec to_map(Tuple.t()) :: Map.t()
  def to_map(tuple) do
    set_node_map tuple, initial_map()
  end

  defp initial_map(), do: %{}

  defp set_node_map({node_name, value, _}, map) do
    Map.put map, node_name, get_node_value(value, Map.get(map, node_name))
  end

  defp get_node_value(value, nil), do: parse_node_value(value)
  defp get_node_value(value, existed_value) when is_list(existed_value) do
    existed_value ++ [parse_node_value(value)]
  end
  defp get_node_value(value, existed_value) do
    [existed_value, parse_node_value(value)]
  end

  defp parse_node_value([]), do: nil
  defp parse_node_value(list) when is_list(list) do
    Enum.reduce list, initial_map(), &set_node_map/2
  end
  defp parse_node_value(value), do: value
end
