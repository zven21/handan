defmodule Handan.Enterprise.Commands.CreateStore do
  @moduledoc false

  @required_fields ~w(store_uuid name)a

  use Handan.EventSourcing.Command

  defcommand do
    field :store_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
    field :logo_url, :string
  end
end
