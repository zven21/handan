defmodule Handan.Selling.Commands.CompleteDeliveryNote do
  @moduledoc false

  @required_fields ~w(delivery_note_uuid sales_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :delivery_note_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
  end
end
