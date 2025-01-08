defmodule Handan.Finance.Commands.DeletePaymentMethod do
  @moduledoc false

  @required_fields ~w(payment_method_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :payment_method_uuid, Ecto.UUID
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Finance.Commands.DeletePaymentMethod

    def enrich(%DeletePaymentMethod{} = cmd, _) do
      # 在这里处理任何需要的数据丰富逻辑
      {:ok, cmd}
    end
  end
end
