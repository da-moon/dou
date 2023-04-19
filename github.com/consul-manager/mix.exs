defmodule ConsulManager.Mixfile do
  use Mix.Project

  def project do
    [
      app: :consul_manager,
      version: "0.0.3",
      elixir: "~> 1.6",
      elixirc_paths: ["lib"],
      compilers: [:phoenix] ++ Mix.compilers(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {ConsulManager, []}, extra_applications: [:logger]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "~> 1.3"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.1", only: :dev},
      {:postgrex, "~> 0.13"},
      {:cowboy, "~> 2.7"},
      {:plug_cowboy, "~> 2.3"},
      {:libcluster, "~> 3.0"},
      {:jason, "~> 1.0"},
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:file_system, "~> 0.2"},
    ]
  end
end
