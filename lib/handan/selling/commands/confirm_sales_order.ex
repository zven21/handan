defmodule Handan.Selling.Commands.ConfirmSalesOrder do
  @moduledoc false

  @required_fields ~w(sales_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :sales_order_uuid, Ecto.UUID
  end
end
