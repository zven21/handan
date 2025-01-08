defmodule Handan.Production.Commands.DeleteWorkstation do
  @moduledoc false

  @required_fields ~w(workstation_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :workstation_uuid, Ecto.UUID
  end
end
