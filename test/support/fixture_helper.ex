defmodule SimpleXmlParser.Support.FixtureHelper do
  @moduledoc """
  Help functions for working with fixtures
  """

  @spec read_fixture_file(String.t()) :: {Atom.t(), String.t()}
  def read_fixture_file(fixture_path) do
    [File.cwd!(), "test", "fixtures", fixture_path]
    |> Path.join()
    |> Path.expand()
    |> File.read()
  end

  @spec read_fixture_file!(String.t()) :: String.t()
  def read_fixture_file!(fixture_path) do
    with {:ok, content} <- read_fixture_file(fixture_path),
         do: content
  end
end
