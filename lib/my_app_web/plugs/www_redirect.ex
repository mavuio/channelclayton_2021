defmodule ElixirWeb.Plugs.WwwRedirect do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    if bare_domain?(conn.host) do
      conn
      |> Phoenix.Controller.redirect(external: www_url(conn))
      |> halt

      # if www_domain?(conn.host) do
      #   conn
      #   |> Phoenix.Controller.redirect(external: bare_url(conn))
      #   |> halt
    else
      # Since all plugs need to return a connection
      conn
    end
  end

  # Returns URL with www prepended for the given connection. Note this also
  # applies to hosts that already contain "www"
  defp www_url(conn) do
    "#{conn.scheme}://www.#{conn.host}#{conn.request_path}"
  end

  # defp bare_url(conn) do
  #   "#{conn.scheme}://#{conn.host |> String.replace_prefix("www.", "")}#{conn.request_path}"
  # end

  # Returns whether the domain is bare (no www)
  defp bare_domain?("localhost"), do: false

  defp bare_domain?(host), do: not www_domain?(host)

  defp www_domain?(host), do: Regex.match?(~r/\Awww\..*\z/i, host)
end
