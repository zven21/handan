defmodule Handan.Accounts.Projectors.User do
  @moduledoc """
  This module handles the projection of user events to the database.
  It listens to UserCreated and UserDeleted events and updates the database accordingly.
  """

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Accounts.Events.{
    UserRegistered
  }

  alias Handan.Accounts.Projections.User

  project(
    %UserRegistered{} = evt,
    _meta,
    fn multi ->
      user = %User{
        uuid: evt.user_uuid,
        mobile: evt.mobile,
        nickname: evt.nickname,
        hashed_password: evt.hashed_password,
        avatar_url: evt.avatar_url,
        bio: evt.bio
      }

      Ecto.Multi.insert(multi, :user_created, user)
    end
  )

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp user_query(uuid) do
    from(c in User, where: c.uuid == ^uuid)
  end
end
