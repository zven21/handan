defmodule Handan.Enterprise.Commands.DeleteCompany do
  @moduledoc false

  @required_fields ~w(company_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :company_uuid, Ecto.UUID
  end
end
