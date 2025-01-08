defmodule Handan.Production.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Production.Aggregates.{
    BOM,
    Process
  }

  alias Handan.Production.Commands.{
    CreateBOM,
    DeleteBOM
  }

  alias Handan.Production.Commands.{
    CreateProcess,
    DeleteProcess
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(BOM, by: :bom_uuid, prefix: "bom-")
  identify(Process, by: :process_uuid, prefix: "process-")

  dispatch(
    [
      CreateBOM,
      DeleteBOM
    ],
    to: BOM,
    lifespan: BOM
  )

  dispatch(
    [
      CreateProcess,
      DeleteProcess
    ],
    to: Process,
    lifespan: Process
  )
end
