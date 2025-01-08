defmodule Handan.Finance.Events.PaymentMethodDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :payment_method_uuid, Ecto.UUID
  end
end
