defmodule SimpleTodoCore.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_todo_core,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      deps: deps(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        deps: deps()
      ]
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
      # We use ecto in the core just for the in memory validation facilities
      {:ecto_sql, "~> 3.0"},
      {:destructure, "~> 0.2.3"},
      {:excoveralls, "~> 0.10", only: :test}
      # {:sibling_app_in_umbrella, in_umbrella: true}
    ]
  end
end
