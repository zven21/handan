defmodule Handan.Stock.Commands.CreateItem do
  @moduledoc false

  @required_fields ~w(item_uuid name selling_price)a

  use Handan.EventSourcing.Command

  defcommand do
    field :item_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
    field :selling_price, :decimal
  end
end
