defmodule Handan.Enterprise.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Enterprise.Aggregates.{
    Store
  }

  alias Handan.Enterprise.Commands.{
    CreateStore,
    DeleteStore
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(Store, by: :store_uuid, prefix: "store-")

  dispatch(
    [
      CreateStore,
      DeleteStore
    ],
    to: Store,
    lifespan: Store
  )
end
