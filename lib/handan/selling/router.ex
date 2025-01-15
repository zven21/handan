defmodule Handan.Selling.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Selling.Aggregates.{
    SalesOrder,
    Customer
  }

  alias Handan.Selling.Commands.{
    CreateSalesOrder,
    DeleteSalesOrder,
    CreateCustomer,
    DeleteCustomer,
    CreateDeliveryNote,
    CreateSalesInvoice,
    CompleteDeliveryNote
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(SalesOrder, by: :sales_order_uuid, prefix: "sales-order-")
  identify(Customer, by: :customer_uuid, prefix: "customer-")

  dispatch(
    [
      CreateSalesOrder,
      DeleteSalesOrder,
      CreateDeliveryNote,
      CreateSalesInvoice,
      CompleteDeliveryNote
    ],
    to: SalesOrder,
    lifespan: SalesOrder
  )

  dispatch(
    [
      CreateCustomer,
      DeleteCustomer
    ],
    to: Customer,
    lifespan: Customer
  )
end
