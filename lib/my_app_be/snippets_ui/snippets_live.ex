defmodule MyAppBe.SnippetsUi.SnippetsLive do
  @moduledoc false

  use MyAppBe, :live_view

  @impl true
  def mount(params, _session, socket) do
    context = %{
      params: params,
      lang: params["lang"] || "de",
      snippets_ui_conf: MavuSnippetsUi.default_conf(%{})
    }

    {:ok,
     socket
     |> assign(
       context: context,
       mavu_snippets_ui_msg: nil
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, _, %{"rec" => rec} = params) do
    socket
    |> update_params_in_context(params)
    |> assign(:page_title, "edit SnippetsUi #{rec}")
  end

  defp apply_action(socket, _, params) do
    socket
    |> update_params_in_context(params)
    |> assign(:page_title, "SnippetsUi List")
  end

  def update_params_in_context(%{assigns: %{context: context}} = socket, new_params)
      when is_map(context),
      do: socket |> assign(:context, put_in(context.params, new_params))

  def update_params_in_context(socket, _), do: socket

  def handle_info({:mavu_snippets_ui_msg, payload}, socket) do
    MavuSnippetsUi.handle_info_from_top_liveview(payload, socket)
  end
end
