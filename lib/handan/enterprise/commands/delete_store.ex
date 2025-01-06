defmodule Handan.Enterprise.Commands.DeleteStore do
  @moduledoc false

  @required_fields ~w(store_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :store_uuid, Ecto.UUID
  end
end
