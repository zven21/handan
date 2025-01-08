defmodule Handan.Enterprise.Events.StaffAdded do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :staff_uuid, Ecto.UUID
    field :name, :string
    field :email, :string
    field :user_uuid, Ecto.UUID
    field :company_uuid, Ecto.UUID
  end
end
