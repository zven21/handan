defmodule Handan.Selling.Commands.DeleteSalesOrder do
  @moduledoc false

  @required_fields ~w(sales_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :sales_order_uuid, Ecto.UUID
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Ecto.Query, warn: false

    alias Handan.Selling.Commands.DeleteSalesOrder
    alias Handan.Repo

    def enrich(%DeleteSalesOrder{} = cmd, _) do
      # 在这里处理任何需要的数据丰富逻辑
      {:ok, cmd}
    end
  end
end
