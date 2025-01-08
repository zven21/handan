defmodule Handan.Accounts.Events.UserRegistered do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :user_uuid, Ecto.UUID
    field :nickname, :string
    field :mobile, :string
    field :avatar_url, :string
    field :bio, :string
    field :hashed_password, :string
    field :invite_code, :string
  end
end
