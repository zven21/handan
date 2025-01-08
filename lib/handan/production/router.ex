defmodule Handan.Production.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Production.Aggregates.{
    BOM
  }

  alias Handan.Production.Commands.{
    CreateBOM,
    DeleteBOM
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(BOM, by: :bom_uuid, prefix: "bom-")

  dispatch(
    [
      CreateBOM,
      DeleteBOM
    ],
    to: BOM,
    lifespan: BOM
  )
end
