defmodule Handan.Enterprise.Events.CompanyCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :company_uuid, Ecto.UUID
    field :owner_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
    field :logo_url, :string
    field :owner_mobile, :string
  end
end
