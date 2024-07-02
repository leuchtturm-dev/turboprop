defmodule Turboprop.MixProject do
  use Mix.Project

  @source_url "https://github.com/leuchtturm-dev/turboprop"
  @version "0.4.2"

  def project do
    [
      app: :turboprop,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Turboprop",
      source_url: @source_url,
      homepage_url: @source_url,
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:deep_merge, "~> 1.0"},
      {:nanoid, "~> 2.0"},
      {:phoenix_live_view, "~> 0.20"},
      {:nimble_parsec, "~> 1.0"},
      {:ex_doc, "~> 0.0", only: :dev, runtime: false},
      {:makeup_html, "~> 0.0", only: :dev, runtime: false},
      {:makeup_eex, "~> 0.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:styler, "== 1.0.0-rc.2", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    A toolkit to build beautiful, accessible components for Phoenix using Tailwind and Zag.
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => @source_url <> "/blob/main/CHANGELOG.md"
      },
      files: [
        ".formatter.exs",
        "CHANGELOG.md",
        "LICENSE",
        "README.md",
        "hooks",
        "lib",
        "mix.exs",
        "package-lock.json",
        "package.json",
        "tsconfig.json"
      ]
    ]
  end

  defp docs do
    [
      main: "Turboprop",
      logo: "assets/turboprop.png",
      source_ref: @version,
      extras: ["CHANGELOG.md"],
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"],
      groups_for_modules: [
        Hooks: ~r/Turboprop.Hooks/,
        Merge: ~r/Turboprop.Merge/,
        Variants: ~r/Turboprop.Variants/
      ]
    ]
  end
end
