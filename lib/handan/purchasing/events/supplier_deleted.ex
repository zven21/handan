defmodule Handan.Purchasing.Events.SupplierDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :supplier_uuid, Ecto.UUID
  end
end
