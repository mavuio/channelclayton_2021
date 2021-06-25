defmodule MyAppWeb.StartpageController do
  @moduledoc false
  use MyAppWeb, :controller

  def startpage(conn, params) do
    render(conn, "startpage.html", context: get_context(params))
  end

  def get_context(params) do
    %{
      params: params,
      lang: params["lang"] || "en"
    }
  end

  def redirect_to_startpage(conn, _opts) do
    conn
    |> redirect(to: "/en")
    |> halt()
  end
end
