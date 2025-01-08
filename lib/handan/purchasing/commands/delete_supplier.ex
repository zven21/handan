defmodule Handan.Purchasing.Commands.DeleteSupplier do
  @moduledoc false

  @required_fields ~w(supplier_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :supplier_uuid, Ecto.UUID
  end
end
