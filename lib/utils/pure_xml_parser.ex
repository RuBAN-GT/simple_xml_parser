defmodule SimpleXmlParser.Utils.PureXmlParser do
  @moduledoc """
  The module can parse pure xml strings
  """

  @typedoc """
  A node object from parser, contains: node name, content, attributes.
  """
  @type xml_node() :: {atom(), list(any) | String.t(), list({atom(), String.t()})}

  @doc ~S"""
  Generate a structure that preserve xml hierarchy and help to parse it to another types

  ## Examples

      Parse a primitive object:
      iex> SimpleXmlParser.Utils.PureXmlParser.parse("<return>Hello!</return>")
      {:return, "Hello!", []}

      Parse an object with attributes:
      iex> SimpleXmlParser.Utils.PureXmlParser.parse("<return id='1'></return>")
      {:return, [], [id: "1"]}

      Parse a complex object:
      iex> "<return><childs><child>1</child></childs></return>"
      ...> |> SimpleXmlParser.Utils.PureXmlParser.parse()
      {:return, [{:childs, [{:child, "1", []}], []}], []}

      iex> "<return><childs><child>1</child><child>2</child></childs></return>"
      ...> |> SimpleXmlParser.Utils.PureXmlParser.parse()
      {:return, [{:childs, [{:child, "1", []}, {:child, "2", []}], []}], []}
  """
  @spec parse(String.t()) :: xml_node()
  def parse(xml_string) do
    xml_string
    |> :erlsom.parse_sax(nil, &sax_handler/2)
    |> get_sax_response()
  end

  @doc ~S"""
  Similar behaviour with original `parse` with the exception of
  parsing from a special node

  ## Examples

      Returns nil for undefined node
      iex> SimpleXmlParser.Utils.PureXmlParser.parse("<return>Hi</return>", :example)
      nil

      Parse a primitive object from `:example`:
      iex> "<return><example>Hello!</example></return>"
      ...> |> SimpleXmlParser.Utils.PureXmlParser.parse(:example)
      {:example, "Hello!", []}

      Parse a list from `:example`:
      iex> "<return><example>1</example><example>2</example></return>"
      ...> |> SimpleXmlParser.Utils.PureXmlParser.parse(:example)
      [{:example, "1", []}, {:example, "2", []}]
  """
  @spec parse(String.t(), atom()) :: xml_node() | nil
  def parse(xml_string, start_node) do
    char_name = to_charlist start_node

    xml_string
    |> :erlsom.parse_sax(nil, fn (info, acc) -> sax_group_handler(info, acc, char_name) end)
    |> get_sax_response()
  end

  # Parse a selected node from sax context
  defp sax_group_handler(info, nil, node_name) do
    case info do
      {:startElement, _, ^node_name, _, _} -> sax_handler(info, [{:fake_root, [], []}])
      _ -> nil
    end
  end

  defp sax_group_handler(:endDocument, [{:fake_root, [node], _}], _), do: node
  defp sax_group_handler(:endDocument, [{:fake_root, nodes, _}], _), do: nodes

  defp sax_group_handler(info, acc, _), do: sax_handler(info, acc)

  # Put a primitive value into tuple
  defp sax_handler({:characters, value}, [{name, _, attrs} | tail]) do
    [{name, to_string(value), attrs} | tail]
  end

  # Put a new element as a first of the working stack
  defp sax_handler({:startElement, _, name, _, attrs}, acc) do
    [{List.to_atom(name), [], map_sax_attributes(attrs)} | acc]
  end

  # Put a head node as a child of the forward node
  defp sax_handler({:endElement, _, _, _}, [element | [head | tail]]) do
    {name, container, attrs} = head
    [{name, container ++ [element], attrs} | tail]
  end

  # Set a root element as root tuple
  defp sax_handler(:endDocument, [response]), do: response

  # Start a document with the working stack
  defp sax_handler(:startDocument, _), do: []

  # Skip another situations
  defp sax_handler(_, acc), do: acc

  defp map_sax_attributes(attrs) do
    attrs
    |> Enum.filter(&match?({:attribute, _, _, _, _}, &1))
    |> Enum.map(fn {:attribute, name, _, _, value} ->
      {List.to_atom(name), to_string(value)}
    end)
  end

  defp get_sax_response({:ok, response, _}), do: response
end
