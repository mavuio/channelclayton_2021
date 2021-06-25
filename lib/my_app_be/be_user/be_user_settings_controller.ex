defmodule MyAppBe.BeUserSettingsController do
  use MyAppBe, :controller

  alias MyApp.BeAccounts
  alias MyAppBe.BeUserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "be_user" => be_user_params} = params
    be_user = conn.assigns.current_be_user

    case BeAccounts.apply_be_user_email(be_user, password, be_user_params) do
      {:ok, applied_be_user} ->
        BeAccounts.deliver_update_email_instructions(
          applied_be_user,
          be_user.email,
          &Routes.be_user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.be_user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "be_user" => be_user_params} = params
    be_user = conn.assigns.current_be_user

    case BeAccounts.update_be_user_password(be_user, password, be_user_params) do
      {:ok, be_user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:be_user_return_to, Routes.be_user_settings_path(conn, :edit))
        |> BeUserAuth.log_in_be_user(be_user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case BeAccounts.update_be_user_email(conn.assigns.current_be_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.be_user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.be_user_settings_path(conn, :edit))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    be_user = conn.assigns.current_be_user

    conn
    |> assign(:email_changeset, BeAccounts.change_be_user_email(be_user))
    |> assign(:password_changeset, BeAccounts.change_be_user_password(be_user))
  end
end
