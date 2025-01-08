defmodule Handan.Purchasing.Events.SupplierCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :supplier_uuid, Ecto.UUID
    field :name, :string
    field :address, :string
  end
end
