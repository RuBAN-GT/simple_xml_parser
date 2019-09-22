defmodule SimpleXmlParser.Utils.PureXmlParser do
  @moduledoc """
  The module can parse pure xml strings
  """

  @typedoc """
  A node object from parser, contains: node name, content, attributes.
  """
  @type xml_node() :: {Atom.t(), List.t() | String.t(), List.t()}

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
  defp sax_handler({:endElement, _, _, _}, [response]), do: response

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
