defmodule ElixirWeb.Plugs.LangAssign do
  @behaviour Plug

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    lang =
      case Cldr.Plug.SetLocale.get_cldr_locale(conn) do
        nil -> Cldr.default_locale().language
        locale -> locale.language
      end

    Plug.Conn.assign(conn, :lang, lang)
  end
end
