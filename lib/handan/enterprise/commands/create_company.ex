defmodule Handan.Enterprise.Commands.CreateCompany do
  @moduledoc false

  @required_fields ~w(company_uuid name)a

  use Handan.EventSourcing.Command

  defcommand do
    field :company_uuid, Ecto.UUID
    # TODO add owner && creator
    # field :user_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
    field :logo_url, :string
  end
end
