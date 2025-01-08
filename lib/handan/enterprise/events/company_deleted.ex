defmodule Handan.Enterprise.Events.CompanyDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :company_uuid, Ecto.UUID
  end
end
