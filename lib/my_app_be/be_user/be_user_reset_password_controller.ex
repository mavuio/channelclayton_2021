defmodule MyAppBe.BeUserResetPasswordController do
  use MyAppBe, :controller

  alias MyApp.BeAccounts

  plug :get_be_user_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"be_user" => %{"email" => email}}) do
    if be_user = BeAccounts.get_be_user_by_email(email) do
      BeAccounts.deliver_be_user_reset_password_instructions(
        be_user,
        &Routes.be_user_reset_password_url(conn, :edit, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your email is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: "/be")
  end

  def edit(conn, _params) do
    render(conn, "edit.html", changeset: BeAccounts.change_be_user_password(conn.assigns.be_user))
  end

  # Do not log in the be_user after reset password to avoid a
  # leaked token giving the be_user access to the account.
  def update(conn, %{"be_user" => be_user_params}) do
    case BeAccounts.reset_be_user_password(conn.assigns.be_user, be_user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Password reset successfully.")
        |> redirect(to: Routes.be_user_session_path(conn, :new))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp get_be_user_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if be_user = BeAccounts.get_be_user_by_reset_password_token(token) do
      conn |> assign(:be_user, be_user) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: "/be")
      |> halt()
    end
  end
end
