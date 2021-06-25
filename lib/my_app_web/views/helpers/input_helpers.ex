defmodule MyAppWeb.InputHelpers do
  use Phoenix.HTML

  import MavuUtils

  def input(form, field, opts \\ []) do
    type = opts[:type] || :text_input

    val = form.params[to_string(field)]

    _has_value = Eigenart.EaHelpers.present?(val)

    classes =
      if opts[:class_override] do
        opts[:class_override]
      else
        "block w-full border-gray-300 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm placeholder-gray-300 " <>
          " #{opts[:class]}"
      end

    input_opts =
      opts
      |> Keyword.drop([:name, :id, :type, :value, :label, :post_text])
      |> Keyword.put(:class, classes)

    has_error = MyAppBe.ErrorHelpers.has_error(form, field)

    label =
      if opts[:label] do
        content_tag(:label, opts[:label],
          class:
            case {type, has_error} do
              {"checkbox", true} -> "pl-2 text-sm font-normal text-gray-700 text-red-600"
              {"checkbox", false} -> "pl-2 text-sm font-normal text-gray-700"
              {_, _} -> "block text-sm font-medium text-gray-700"
            end,
          for: Phoenix.HTML.Form.input_id(form, field)
        )
      else
        ""
      end

    input_opts =
      if has_error do
        Keyword.put(
          input_opts,
          :class,
          "block w-full pr-10 text-red-900 placeholder-red-300 border-red-300 rounded-md focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm"
        )
      else
        input_opts
      end

    {label, input} =
      case type do
        "checkbox" ->
          cb_input_opts =
            input_opts
            |> Keyword.put(
              :class,
              " mt-1 border-gray-300  shadow-sm focus:ring-primary-500 focus:border-primary-500  rounded text-primary-700 " <>
                " #{opts[:class]}"
            )

          {"",
           content_tag(
             :div,
             [Phoenix.HTML.Form.checkbox(form, field, cb_input_opts), label],
             class: "flex"
           )}

        "select" ->
          {label,
           Phoenix.HTML.Form.select(
             form,
             field,
             opts[:items],
             input_opts |> Keyword.drop([:items])
           )}

        _ ->
          {label,
           apply(
             Phoenix.HTML.Form,
             type,
             [form, field, input_opts]
           )}
      end

    input_w_errormarker =
      case has_error do
        true -> add_error_marker_to_input(input)
        false -> input
      end

    input_wrapped =
      if opts[:nowrap] do
        input_w_errormarker
      else
        content_tag(:div, input_w_errormarker, class: "mt-1")
      end

    inputfield = [label, input_wrapped, opts[:post_text] |> if_nil("")]

    error = MyAppBe.ErrorHelpers.error_tag(form, field) |> if_nil("")
    [inputfield, error]
  end

  def add_error_marker_to_input(input) do
    ~E"""
    <div class="relative mt-1 rounded-md shadow-sm">
      <%= input  %>
      <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
        <!-- Heroicon name: exclamation-circle -->
          <svg class="w-5 h-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
          </svg>
      </div>
    </div>
    """
  end

  def input_state_class(%{source: source} = form, field) when is_map(source) do
    cond do
      # The form was not yet submitted
      !form.source.action ->
        ""

      form.errors[field] ->
        "is-invalid"

      # ""

      true ->
        # "is-valid"
        ""
    end
  end

  def input_state_class(_form, _field), do: ""

  def body_classes(conn) do
    "c-#{Phoenix.Controller.controller_module(conn) |> Phoenix.Naming.resource_name("Controller")} a-#{Phoenix.Controller.action_name(conn)}"
  end
end
