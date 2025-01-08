defmodule Handan.Selling.Commands.CreateCustomer do
  @moduledoc false

  @required_fields ~w(customer_uuid name address)a

  use Handan.EventSourcing.Command

  defcommand do
    field :customer_uuid, Ecto.UUID
    field :name, :string
    field :address, :string
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Selling.Commands.CreateCustomer

    def enrich(%CreateCustomer{} = cmd, _) do
      # 在这里处理任何需要的数据丰富逻辑
      {:ok, cmd}
    end
  end
end
