defmodule Fireblast.MixProject do
  use Mix.Project

  def project do
    [
      app: :fireblast,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
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
      {:exx, github: "olafura/exx", branch: "something_better"},
      {:uuid, "~> 1.1"}
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
