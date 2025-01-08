defmodule Handan.Finance.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Finance.Aggregates.{
    PaymentMethod
  }

  alias Handan.Finance.Commands.{
    CreatePaymentMethod,
    DeletePaymentMethod
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(PaymentMethod, by: :payment_method_uuid, prefix: "payment-method-")

  dispatch(
    [
      CreatePaymentMethod,
      DeletePaymentMethod
    ],
    to: PaymentMethod,
    lifespan: PaymentMethod
  )
end
