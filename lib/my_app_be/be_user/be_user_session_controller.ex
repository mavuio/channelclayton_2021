defmodule MyAppBe.BeUserSessionController do
  use MyAppBe, :controller

  alias MyApp.BeAccounts
  alias MyAppBe.BeUserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"be_user" => be_user_params}) do
    %{"email" => email, "password" => password} = be_user_params

    with {:ok, be_user} <- BeAccounts.get_be_user_by_email_and_password(email, password) do
      BeUserAuth.log_in_be_user(conn, be_user, be_user_params)
    else
      {:error, :bad_username_or_password} ->
        render(conn, "new.html", error_message: "Invalid e-mail or password")

      {:error, :not_active} ->
        render(conn, "new.html", error_message: "your account is not active")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> BeUserAuth.log_out_be_user()
  end
end
