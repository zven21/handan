defmodule Handan.Production.Commands.DeleteBOM do
  @moduledoc false

  @required_fields ~w(bom_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :bom_uuid, Ecto.UUID
  end
end
