defmodule MyAppBe.BeUserUi.BeUserLive do
  @moduledoc false

  use MyAppBe, :live_view

  @impl true
  def mount(params, _session, socket) do
    context = %{
      params: params,
      lang: params["lang"] || "de",
      be_user_ui_conf: MavuBeUserUi.default_conf(%{})
    }

    {:ok,
     socket
     |> assign(context: context)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, _, %{"rec" => rec} = params) do
    socket
    |> update_params_in_context(params)
    |> assign(:page_title, "edit User #{rec}")
  end

  defp apply_action(socket, _, params) do
    socket
    |> update_params_in_context(params)
    |> assign(:page_title, "User List")
  end

  def update_params_in_context(%{assigns: %{context: context}} = socket, new_params)
      when is_map(context),
      do: socket |> assign(:context, put_in(context.params, new_params))

  def update_params_in_context(socket, _), do: socket
end
