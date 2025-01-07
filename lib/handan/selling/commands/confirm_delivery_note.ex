defmodule Handan.Selling.Commands.ConfirmDeliveryNote do
  @moduledoc false

  @required_fields ~w(sales_invoice_uuid sales_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :delivery_note_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
  end
end
