defmodule Handan.Production.Commands.DeleteProcess do
  @moduledoc false

  @required_fields ~w(process_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :process_uuid, Ecto.UUID
  end
end
