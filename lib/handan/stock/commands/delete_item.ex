defmodule Handan.Stock.Commands.DeleteItem do
  @moduledoc false

  @required_fields ~w(item_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :item_uuid, Ecto.UUID
  end
end
