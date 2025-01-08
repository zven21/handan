defmodule Handan.Accounts.Aggregates.User do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :user_uuid, Ecto.UUID
    field :nickname, :string
    field :email, :string
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

  # @doc """
  # Stop the comment aggregate after it has been deleted
  # """
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # register
  def execute(%__MODULE__{}, %RegisterUser{} = cmd) do
    %UserRegistered{
      user_uuid: cmd.user_uuid,
      nickname: cmd.nickname,
      email: cmd.email,
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
        email: evt.email,
        hashed_password: evt.hashed_password
    }
  end
end
