defmodule Elavon.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elavon,
      description: "Native elixir client for USBank Elavon Converge API",
      version: "0.1.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      docs: docs(),
      package: package(),
      source_url: "https://github.com/infinitered/elavon-elixir"
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
     {:httpoison, "~> 0.13"},
     {:poison, "~> 3.1"},
     {:excoveralls, "~> 0.7", only: :test},
     {:ex_doc, "~> 0.16", only: [:dev, :test]}
    ]
  end

  defp docs do
    [
      readme: "README.md",
      main: Elavon
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      maintainers: ["Zachary Berkompas"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/infinitered/elavon-elixir"
      }
    ]
  end
end
