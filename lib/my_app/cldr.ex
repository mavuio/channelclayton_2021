defmodule MyApp.Cldr do
  use Cldr,
    default_locale: "de",
    locales: ["de"],
    gettext: MyAppWeb.Gettext,
    data_dir: "./priv/cldr",
    providers: [Cldr.Territory, Cldr.Number, Cldr.Calendar, Cldr.DateTime],
    otp_app: :my_app

  def langs do
    [
      %{slug: "de", label: "DE"}
      # %{slug: "en", label: "EN"}
    ]
  end

  def current_language(lang) when is_binary(lang) do
    langs()
    |> Enum.find(&(&1.slug == lang))
  end

  def other_langs(conn, lang) when is_binary(lang) do
    path_rest =
      Phoenix.Controller.current_path(conn)
      |> String.replace_prefix("/#{lang}", "")

    langs()
    |> Enum.filter(&(&1.slug != lang))
    |> Enum.map(fn a -> a |> Map.put(:link, "/#{a.slug}#{path_rest}") end)
  end
end
