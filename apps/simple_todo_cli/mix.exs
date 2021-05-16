defmodule SimpleTodoCli.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_todo_cli,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: SimpleTodoCli.Main],
      deps: deps()
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
      {:simple_todo_core, in_umbrella: true},
      {:csv, "~> 2.4"},
      {:scribe, "~> 0.10"}
    ]
  end
end
