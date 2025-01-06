defmodule Handan.Selling.Events.CustomerCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :customer_uuid, Ecto.UUID
    field :name, :string
    field :address, :string
  end
end
