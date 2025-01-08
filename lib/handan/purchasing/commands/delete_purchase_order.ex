defmodule Handan.Purchasing.Commands.DeletePurchaseOrder do
  @moduledoc false

  @required_fields ~w(purchase_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :purchase_order_uuid, Ecto.UUID
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Ecto.Query, warn: false
    alias Handan.Purchasing.Commands.DeletePurchaseOrder

    def enrich(%DeletePurchaseOrder{} = cmd, _) do
      # 在这里处理任何需要的数据丰富逻辑
      {:ok, cmd}
    end
  end
end
