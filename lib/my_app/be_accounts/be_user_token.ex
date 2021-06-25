defmodule MyApp.BeAccounts.BeUserToken do
  use Ecto.Schema
  import Ecto.Query

  @hash_algorithm :sha256
  @rand_size 32

  # It is very important to keep the reset password token expiry short,
  # since someone with access to the email may take over the account.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  schema "be_users_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :be_user, MyApp.BeAccounts.BeUser

    timestamps(updated_at: false)
  end

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.
  """
  def build_session_token(be_user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %MyApp.BeAccounts.BeUserToken{token: token, context: "session", be_user_id: be_user.id}}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the be_user found by the token.
  """
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: be_user in assoc(token, :be_user),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: be_user

    {:ok, query}
  end

  @doc """
  Builds a token with a hashed counter part.

  The non-hashed token is sent to the be_user email while the
  hashed part is stored in the database, to avoid reconstruction.
  The token is valid for a week as long as be_users don't change
  their email.
  """
  def build_email_token(be_user, context) do
    build_hashed_token(be_user, context, be_user.email)
  end

  defp build_hashed_token(be_user, context, sent_to) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %MyApp.BeAccounts.BeUserToken{
       token: hashed_token,
       context: context,
       sent_to: sent_to,
       be_user_id: be_user.id
     }}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the be_user found by the token.
  """
  def verify_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
        days = days_for_context(context)

        query =
          from token in token_and_context_query(hashed_token, context),
            join: be_user in assoc(token, :be_user),
            where: token.inserted_at > ago(^days, "day") and token.sent_to == be_user.email,
            select: be_user

        {:ok, query}

      :error ->
        :error
    end
  end

  defp days_for_context("confirm"), do: @confirm_validity_in_days
  defp days_for_context("reset_password"), do: @reset_password_validity_in_days

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the be_user token record.
  """
  def verify_change_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

        query =
          from token in token_and_context_query(hashed_token, context),
            where: token.inserted_at > ago(@change_email_validity_in_days, "day")

        {:ok, query}

      :error ->
        :error
    end
  end

  @doc """
  Returns the given token with the given context.
  """
  def token_and_context_query(token, context) do
    from MyApp.BeAccounts.BeUserToken, where: [token: ^token, context: ^context]
  end

  @doc """
  Gets all tokens for the given be_user for the given contexts.
  """
  def be_user_and_contexts_query(be_user, :all) do
    from t in MyApp.BeAccounts.BeUserToken, where: t.be_user_id == ^be_user.id
  end

  def be_user_and_contexts_query(be_user, [_ | _] = contexts) do
    from t in MyApp.BeAccounts.BeUserToken, where: t.be_user_id == ^be_user.id and t.context in ^contexts
  end
end
