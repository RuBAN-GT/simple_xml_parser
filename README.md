# SimpleXmlParser

![Hex.pm](https://img.shields.io/hexpm/v/simple_xml_parser)

The package can help to parse complex xml structures into internal Elixir data types.

## Examples

```elixir
  iex> SimpleXmlParser.xml_to_map("<return i='1'>Hello world!</return>")
  %{return: "Hello world!"}

  iex> SimpleXmlParser.xml_to_map("<return><item>1</item><item>2</item></return>")
  %{return: %{item: ["1", "2"]}}
```

You can find more examples in method documentation.

## TODO

* [x] Simple maps
* [x] Attribute support
* [ ] Think about source formation
* [ ] Benchmarks and optimization

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `simple_xml_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simple_xml_parser, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/simple_xml_parser](https://hexdocs.pm/simple_xml_parser).
