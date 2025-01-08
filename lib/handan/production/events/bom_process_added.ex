defmodule Handan.Production.Events.BOMProcessAdded do
  @moduledoc false
  use Handan.EventSourcing.Event

  defevent do
    field :bom_process_uuid, Ecto.UUID
    field :bom_uuid, Ecto.UUID
    field :process_uuid, Ecto.UUID
    field :process_name, :string
    field :position, :integer
    field :tool_required, :string
  end
end
