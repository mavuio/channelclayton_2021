defmodule MyAppBe.BeUserRegistrationController do
  use MyAppBe, :controller

  alias MyApp.BeAccounts
  alias MyApp.BeAccounts.BeUser
  alias MyAppWeb.Router.Helpers, as: Routes

  def new(conn, _params) do
    changeset = BeAccounts.change_be_user_registration(%BeUser{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"be_user" => be_user_params}) do
    case BeAccounts.register_be_user(be_user_params) do
      {:ok, be_user} ->
        # {:ok, _} =
        #   BeAccounts.deliver_be_user_confirmation_instructions(
        #     be_user,
        #     &Routes.be_user_confirmation_url(conn, :confirm, &1)
        #   )

        # if this user is the first one in the database:
        if BeAccounts.get_number_of_be_users() == 1 do
          BeAccounts.activate_user(be_user, true)
        end

        conn
        |> put_flash(:info, "Backend-User created successfully.")
        |> redirect(to: Routes.be_user_session_path(conn, :new))

      # |> BeUserAuth.log_in_be_user(be_user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
