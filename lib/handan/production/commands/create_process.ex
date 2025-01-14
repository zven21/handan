defmodule Handan.Production.Commands.CreateProcess do
  @moduledoc false

  @required_fields ~w(process_uuid name)a

  use Handan.EventSourcing.Command

  defcommand do
    field :process_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
  end
end
