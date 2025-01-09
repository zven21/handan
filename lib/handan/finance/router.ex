defmodule Handan.Finance.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Finance.Aggregates.{
    PaymentMethod,
    PaymentEntry
  }

  alias Handan.Finance.Commands.{
    CreatePaymentMethod,
    DeletePaymentMethod
  }

  alias Handan.Finance.Commands.{
    CreatePaymentEntry,
    DeletePaymentEntry
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(PaymentMethod, by: :payment_method_uuid, prefix: "payment-method-")
  identify(PaymentEntry, by: :payment_entry_uuid, prefix: "payment-entry-")

  dispatch(
    [
      CreatePaymentMethod,
      DeletePaymentMethod
    ],
    to: PaymentMethod,
    lifespan: PaymentMethod
  )

  dispatch(
    [
      CreatePaymentEntry,
      DeletePaymentEntry
    ],
    to: PaymentEntry,
    lifespan: PaymentEntry
  )
end
