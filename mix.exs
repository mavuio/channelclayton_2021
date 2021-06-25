defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MyApp.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 2.0"},
      {:phoenix, "~> 1.5.9"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.15.1"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:ex_cldr, "~> 2.0"},
      {:ex_cldr_territories, "~> 2.0"},
      {:ex_cldr_dates_times, "~> 2.0"},
      {:tzdata, "~> 1.0.1"},
      {:phoenix_active_link, "~> 0.3"},
      {:atomic_map, "~> 0.8"},
      {:number, "~> 1.0.1"},
      {:happy_with, "~> 1.0"},
      {:mavu_utils, "~> 0.1.0"},
      {:quick_alias, github: "mavuio/quick_alias", branch: "master"},
      {:mavu_form, "~> 0.1.0"},
      {:mavu_content, "~> 0.1.0"},
      {:mavu_be_user_ui, "~> 0.1.0"},
      {:mavu_snippets_ui, "~> 0.1.0"},
      {:pit, "~> 1.2.0"},
      {:mavu_list, "~> 0.1.9"},
      {:heroicons, "~> 0.1.0"},
      {:exconstructor, "~> 1.1"},
      {:typed_struct, "~> 0.2.1"},
      {:oban, "~> 2.6"},
      {:phx_gen_auth, "~> 0.7", only: [:dev], runtime: false},
      {:bamboo, "~> 2.1"},
      {:bamboo_phoenix, "~> 1.0.0"},
      {:bamboo_smtp, "~> 4.0.1", only: :dev},
      {:exsync, "~> 0.2", only: :dev}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
