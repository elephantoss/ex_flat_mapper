defmodule FlatMapper.MixProject do
  @moduledoc false

  use Mix.Project

  @source_url "https://github.com/elephantoss/ex_flat_mapper"
  @version "0.2.0"

  def project do
    [
      app: :flat_mapper,
      version: @version,
      config_path: "./config/config.exs",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        ensure_consistency: :test
      ],
      source_url: @source_url,
      homepage_url: @source_url,
      xref: [exclude: [Jason]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.14.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.28.5", only: :dev, runtime: false},
      {:inch_ex, "~> 2.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:git_ops, "~> 2.5.0", only: [:dev, :test]},
      {:timex, "~> 3.7"}
    ]
  end

  defp docs do
    [
      main: "readme",
      assets: "assets",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: [
        "README.md",
        "CHANGELOG.md": [title: "Changelog"]
      ]
    ]
  end

  defp description do
    """
    Flat nested types (maps, lists, structs) library for Elixir.
    """
  end

  #  package info for publishing to Hex.pm
  defp package do
    [
      files: ~w(lib LICENSE.md mix.exs README.md),
      name: "flat_mapper",
      licenses: ["MIT"],
      maintainers: ["elephantoss"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp aliases do
    [
      docs_html: ["docs --formattter html -o doc/ex_doc"],
      ensure_consistency: [
        "test",
        "dialyzer",
        "credo --strict",
        "inch",
        "coveralls"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
