defmodule Fireblast.MixProject do
  use Mix.Project

  def project do
    [
      app: :fireblast,
      version: "0.1.6",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Fireblast is html component library",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_xml, "~> 0.1"},
      {:uuid, "~> 1.1"},
      {:phoenix_html, "~> 4.2"}
    ]
  end

  defp package do
    [
      maintainers: ["Olafur Arason"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/fireblast-ui/fireblast"},
      files: ~w(lib LICENSE mix.exs README.md)
    ]
  end
end
