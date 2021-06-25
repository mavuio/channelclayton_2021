defmodule MyApp.Error do
  defexception [:code, :plug_status, :message, :meta]

  def new(code, plug_status, message, meta) when is_binary(message) and is_integer(plug_status) do
    %__MODULE__{code: code, plug_status: plug_status, message: message, meta: Map.new(meta)}
  end

  def not_found(message, meta \\ %{}) do
    new(:not_found, 404, message, meta)
  end

  def internal(message, meta \\ %{}) do
    new(:internal, 500, message, meta)
  end
end
