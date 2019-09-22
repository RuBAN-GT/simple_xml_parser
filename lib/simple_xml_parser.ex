defmodule SimpleXmlParser do
  @moduledoc """
  The simple parser of xml string to different types
  """

  alias SimpleXmlParser.Utils.PureXmlParser
  alias SimpleXmlParser.Utils.TreeParser

  @doc """
  Convert the input xml string to a map ignoring attributes

  ## Examples

      Parse an empty object
      iex> SimpleXmlParser.xml_to_map("<return i='1'>Hello world!</return>")
      %{return: "Hello world!"}

      Parse a collection
      iex> SimpleXmlParser.xml_to_map("<return><item>1</item><item>2</item></return>")
      %{return: %{item: ["1", "2"]}}
  """
  def xml_to_map(input) do
    input
    |> PureXmlParser.parse()
    |> TreeParser.to_map()
  end
end
