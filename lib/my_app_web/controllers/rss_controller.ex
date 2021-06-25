defmodule MyAppWeb.RssController do
  @moduledoc false
  use MyAppWeb, :controller
  alias MyApp.Episodes

  def startpage(conn, params) do
    render(conn, "startpage.html", context: get_context(params))
  end

  def episode_json(conn, %{"episode_num" => episode_num}) do
    conn
    |> put_resp_content_type("application/json")
    |> text(Jason.encode!(Episodes.get_episode_config(MavuUtils.to_int(episode_num))))
  end

  def general_feed_xml(conn, _params) do
    conn
    |> put_resp_content_type("text/xml")
    |> put_root_layout(false)
    |> render("general_feed.xml", [])
  end

  def episodes_rss_xml(conn, _params) do
    conn
    |> put_resp_content_type("text/xml")
    |> put_root_layout(false)
    |> render("episodes_rss.xml", [])
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
