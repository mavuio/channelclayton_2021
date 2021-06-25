defmodule MyAppBe.BeUserConfirmationController do
  use MyAppBe, :controller

  alias MyApp.BeAccounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"be_user" => %{"email" => email}}) do
    if be_user = BeAccounts.get_be_user_by_email(email) do
      BeAccounts.deliver_be_user_confirmation_instructions(
        be_user,
        &Routes.be_user_confirmation_url(conn, :confirm, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> redirect(to: "/")
  end

  # Do not log in the be_user after confirmation to avoid a
  # leaked token giving the be_user access to the account.
  def confirm(conn, %{"token" => token}) do
    case BeAccounts.confirm_be_user(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Be user confirmed successfully.")
        |> redirect(to: "/")

      :error ->
        # If there is a current be_user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the be_user themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_be_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(:error, "Be user confirmation link is invalid or it has expired.")
            |> redirect(to: "/")
        end
    end
  end
end
