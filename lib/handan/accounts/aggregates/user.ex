defmodule Handan.Accounts.Aggregates.User do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :user_uuid, Ecto.UUID
    field :nickname, :string
    field :mobile, :string
    field :avatar_url, :string
    field :is_admin, :boolean, default: false
    field :hashed_password, :string
  end

  alias Handan.Accounts.Commands.{
    RegisterUser
  }

  alias Handan.Accounts.Events.{
    UserRegistered
  }

  # register
  def execute(%__MODULE__{}, %RegisterUser{} = cmd) do
    %UserRegistered{
      user_uuid: cmd.user_uuid,
      nickname: cmd.nickname,
      mobile: cmd.mobile,
      avatar_url: cmd.avatar_url,
      hashed_password: cmd.hashed_password
    }
  end

  # state mutators
  def apply(%__MODULE__{} = user, %UserRegistered{} = evt) do
    %{
      user
      | user_uuid: evt.user_uuid,
        nickname: evt.nickname,
        mobile: evt.mobile,
        hashed_password: evt.hashed_password
    }
  end
end
