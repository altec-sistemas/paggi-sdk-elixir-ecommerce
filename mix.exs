defmodule Paggi.MixProject do
  use Mix.Project

  def project, do: [
    app: :paggi,
    version: "0.1.0",
    elixirc_paths: elixirc_paths(Mix.env),
    elixir: "~> 1.8",
    start_permanent: Mix.env() == :prod,
    deps: deps()
  ]

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_env), do: ["lib"]

  def application, do: [
    extra_applications: [:logger]
  ]

  defp deps, do: [
    {:httpoison, "~> 1.5"},
    {:poison, "~> 4.0"}
  ]
end
