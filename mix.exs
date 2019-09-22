defmodule SimpleXmlParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_xml_parser,
      description: "The package can help to parse complex xml structures into internal Elixir data types.",
      package: package(),
      version: "0.0.1",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:erlsom, "~> 1.5"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:faker, "~> 0.12", only: :test},
      {:stream_data, "~> 0.1", only: :test},
      {:xml_builder, "~> 2.1.1", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Dmitry Ruban"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/RuBAN-GT/simple_xml_parser",
        source_url: "https://github.com/RuBAN-GT/simple_xml_parser",
        homepage_url: "https://github.com/RuBAN-GT/simple_xml_parser"
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "test/support"]
end
