defmodule Handan.Production.Events.WorkstationDeleted do
  @moduledoc """
  工作站删除的事件。
  """

  use Handan.EventSourcing.Event

  defevent do
    field :workstation_uuid, Ecto.UUID
  end
end
