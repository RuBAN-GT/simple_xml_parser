defmodule SimpleXmlParser.Utils.PureXmlParserTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest SimpleXmlParser.Utils.PureXmlParser

  alias SimpleXmlParser.Utils.PureXmlParser, as: Parser

  def attr_generator, do: string(Enum.concat([?a..?z, ?A..?Z]), min_length: 1)

  describe "SimpleXmlParser.Utils.PureXmlParser.parse/1" do
    test "returns an empty tuple from from xml without nested data" do
      check all attr_str <- attr_generator(),
                attr = String.to_atom(attr_str),
                xml = {attr, nil, nil} |> XmlBuilder.generate() do
        assert {attr, [], []} = Parser.parse(xml)
      end
    end

    test "returns a value from a primitive object from xml" do
      check all attr_str <- attr_generator(),
                attr = String.to_atom(attr_str),
                content <- string(:alphanumeric, min_length: 1),
                xml = {attr, nil, content} |> XmlBuilder.generate() do
        assert {attr, content, []} = Parser.parse(xml)
      end
    end

    test "returns a map from a single object from xml" do
      check all id <- integer(),
                common_id = Integer.to_string(id),
                name <- string(:alphanumeric, min_length: 1),
                xml = {:return, nil, [{:id, nil, common_id}, {:name, nil, name}]} |> XmlBuilder.generate() do
        assert {:return, [{:id, common_id, []}, {:name, name, []}], _} = Parser.parse(xml)
      end
    end

    test "returns a tree-map from a complex object from xml" do
      check all sample <- string(:alphanumeric, min_length: 1),
                xml = {:return, nil, [{:childs, nil, [{:child, nil, sample}]}]} |> XmlBuilder.generate() do
        assert {:return, [{:childs, [{:child, sample, []}], []}], []} = Parser.parse(xml)
      end
    end
  end
end
