defmodule Handan.Accounts.Projections.User do
  @moduledoc false

  use Ecto.Schema
  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :nickname, :string
    field :avatar_url, :string
    field :bio, :string
    field :hashed_password, :string, redact: true
    field :confirmed_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%__MODULE__{hashed_password: hashed_password}, password) when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end
end
