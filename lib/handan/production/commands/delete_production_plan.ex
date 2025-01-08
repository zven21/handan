defmodule Handan.Production.Commands.DeleteProductionPlan do
  @moduledoc false

  @required_fields ~w(plan_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :production_plan_uuid, Ecto.UUID
  end
end
