defmodule MyAppWeb.FrontendHelpers do
  use Phoenix.HTML

  import Pit

  def body_classes(conn) do
    "c-#{Phoenix.Controller.controller_module(conn) |> Phoenix.Naming.resource_name("Controller")} a-#{Phoenix.Controller.action_name(conn)}"
  end

  def tw_icon(icon_fun, size) when is_integer(size) and is_function(icon_fun, 1) do
    icon_fun.(class: "w-#{size} h-#{size}") |> Phoenix.HTML.raw()
  end

  def tw_icon(icon_fun, class) when is_binary(class) and is_function(icon_fun, 1) do
    icon_fun.(class: class) |> Phoenix.HTML.raw()
  end

  def tw_icon(icon_fun, opts) when is_list(opts) and is_function(icon_fun, 1) do
    icon_fun.(opts) |> Phoenix.HTML.raw()
  end

  def tw_class(class_name, opts \\ [])

  def tw_class(:narrow_container, _), do: "max-w-md  mx-auto"
  def tw_class(_, _), do: ""

  def rss_date(utc_date) do
    utc_date
    |> local_date()
    |> DateTime.from_naive("Europe/Vienna")
    |> pit(date <- {:ok, date})
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S %z")
  end

  def atom_date(utc_date) do
    utc_date
    |> local_date()
    |> DateTime.from_naive("Europe/Vienna")
    |> pit(date <- {:ok, date})
    |> Calendar.strftime("%Y-%m-%dT%H:%M:%S%z")
  end

  defdelegate local_date(utc_date), to: MyAppWeb.MyHelpers

  defdelegate trans(lang_or_params, txt_en, txt_de \\ nil), to: MyAppWeb.MyHelpers

  defdelegate lang_from_params(lang_or_params), to: MyAppWeb.MyHelpers

  defdelegate if_empty(val, default_val), to: MavuUtils
  defdelegate if_nil(val, default_val), to: MavuUtils
  defdelegate present?(term), to: MavuUtils
  defdelegate empty?(term), to: MavuUtils
  defdelegate true?(term), to: MavuUtils
  defdelegate false?(term), to: MavuUtils

  def snip(lang_or_params, key, default \\ nil, variables \\ []),
    do: MavuSnippets.snip(lang_or_params, key, default, variables)

  def path_to_current_page(%{current_url: current_url} = context, lang)
      when is_binary(current_url) and is_binary(lang) do
    uri = URI.parse(current_url)

    path = String.replace(uri.path, ~r|^/[^/]+/|, "/#{lang}/")

    if uri.query do
      "#{path}?#{uri.query}"
    else
      path
    end
  end

  def path_to_current_page(_, _), nil

  def add_url_to_context(socket, url) when is_map(socket) and is_binary(url) do
    socket
    |> Phoenix.LiveView.assign(
      context:
        put_in(
          socket.assigns.context,
          [:current_url],
          url
        )
    )
  end
end
