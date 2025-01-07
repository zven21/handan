defmodule Handan.Selling.Events.SalesOrderConfirmed do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :status, :string
    field :sales_order_uuid, Ecto.UUID
  end
end
