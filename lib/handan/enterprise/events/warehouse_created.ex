defmodule Handan.Enterprise.Events.WarehouseCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :warehouse_uuid, Ecto.UUID
    field :name, :string
    field :store_uuid, Ecto.UUID
    field :address, :string
    field :contact_name, :string
    field :contact_mobile, :string
    field :is_default, :boolean
  end
end
