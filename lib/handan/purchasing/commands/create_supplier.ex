defmodule Handan.Purchasing.Commands.CreateSupplier do
  @moduledoc false

  @required_fields ~w(supplier_uuid name address)a

  use Handan.EventSourcing.Command

  defcommand do
    field :supplier_uuid, Ecto.UUID
    field :name, :string
    field :address, :string
  end
end
