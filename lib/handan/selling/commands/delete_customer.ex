defmodule Handan.Selling.Commands.DeleteCustomer do
  @moduledoc false

  @required_fields ~w(customer_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :customer_uuid, Ecto.UUID
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Ecto.Query, warn: false

    alias Handan.Selling.Commands.DeleteCustomer

    def enrich(%DeleteCustomer{} = cmd, _) do
      # 在这里处理任何需要的数据丰富逻辑
      {:ok, cmd}
    end
  end
end
