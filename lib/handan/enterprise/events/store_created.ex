defmodule Handan.Enterprise.Events.StoreCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :store_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
    field :logo_url, :string
  end
end
