defmodule Handan.Accounts.Commands.RegisterUser do
  @moduledoc false

  @required_fields ~w(user_uuid email password)a

  use Handan.EventSourcing.Command

  defcommand do
    field :user_uuid, Ecto.UUID
    field :nickname, :string
    field :email, :string
    field :password, :string
    field :avatar_url, :string
    field :hashed_password, :string
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Accounts.Commands.RegisterUser

    def enrich(%RegisterUser{password: password, email: email} = cmd, _) do
      case Handan.Accounts.get_user_by_email(email) do
        nil ->
          hashed_password = Bcrypt.hash_pwd_salt(password)
          {:ok, %RegisterUser{cmd | password: nil, hashed_password: hashed_password}}

        _user ->
          {:error, %{email: "has already taken"}}
      end
    end
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, fields())
    |> validate_required_fields(@required_fields)
    |> validate_length(:nickname, min: 1, max: 50)
    |> validate_format(:email, ~r/\A[^\s@]+@[^\s@]+\.[^\s@]+\z/, message: "must have the correct format")
  end
end
