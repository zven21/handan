defmodule Handan.Production.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Production.Aggregates.{
    BOM,
    Process,
    Workstation
    # ProductionPlan
  }

  alias Handan.Production.Commands.{
    CreateBOM,
    DeleteBOM
  }

  alias Handan.Production.Commands.{
    CreateProcess,
    DeleteProcess
  }

  alias Handan.Production.Commands.{
    CreateWorkstation,
    DeleteWorkstation
  }

  # alias Handan.Production.Commands.{
  #   CreateProductionPlan,
  #   DeleteProductionPlan
  # }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(BOM, by: :bom_uuid, prefix: "bom-")
  identify(Process, by: :process_uuid, prefix: "process-")
  identify(Workstation, by: :workstation_uuid, prefix: "workstation-")
  # identify(ProductionPlan, by: :production_plan_uuid, prefix: "production-plan-")

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

  dispatch(
    [
      CreateWorkstation,
      DeleteWorkstation
    ],
    to: Workstation,
    lifespan: Workstation
  )

  # dispatch(
  #   [
  #     CreateProductionPlan,
  #     DeleteProductionPlan
  #   ],
  #   to: ProductionPlan,
  #   lifespan: ProductionPlan
  # )
end
