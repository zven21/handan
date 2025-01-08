defmodule Handan.Accounts.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Accounts.Aggregates.{
    User
  }

  alias Handan.Accounts.Commands.{
    RegisterUser
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(User, by: :user_uuid, prefix: "user-")

  dispatch(
    [
      RegisterUser
    ],
    to: User,
    lifespan: User
  )
end
