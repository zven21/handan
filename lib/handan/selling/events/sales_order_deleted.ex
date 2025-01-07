defmodule Handan.Selling.Events.SalesOrderDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_order_uuid, Ecto.UUID
  end
end
