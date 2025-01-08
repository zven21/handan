defmodule Handan.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Handan.Turbo
  alias Handan.Repo

  alias Handan.Accounts.Projections.{User, UserToken}

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by mobile.
  """
  def get_user_by_mobile(mobile) when is_binary(mobile) do
    Repo.get_by(User, mobile: mobile)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  ## Session

  @doc "login"
  def login(%{mobile: mobile, password: password}) when is_binary(mobile) and is_binary(password) do
    with {:ok, user} <- Turbo.get_by(User, %{mobile: mobile}),
         true <- User.valid_password?(user, password) do
      token = generate_user_session_token(user)
      {:ok, %{user: user, token: token}}
    else
      _ -> {:error, :invalid_mobile_or_password}
    end
  end

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end
end
