defmodule Handan.Finance.Events.PaymentMethodCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :payment_method_uuid, Ecto.UUID
    field :name, :string
  end
end
