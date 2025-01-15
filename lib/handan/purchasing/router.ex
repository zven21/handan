defmodule Handan.Purchasing.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Purchasing.Aggregates.{
    PurchaseOrder,
    Supplier
  }

  alias Handan.Purchasing.Commands.{
    CreateSupplier,
    DeleteSupplier
  }

  alias Handan.Purchasing.Commands.{
    CreatePurchaseOrder,
    DeletePurchaseOrder,
    CreatePurchaseInvoice,
    CreateReceiptNote,
    CompleteReceiptNote
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(Supplier, by: :supplier_uuid, prefix: "supplier-")
  identify(PurchaseOrder, by: :purchase_order_uuid, prefix: "purchase-order-")

  dispatch(
    [
      CreateSupplier,
      DeleteSupplier
    ],
    to: Supplier,
    lifespan: Supplier
  )

  dispatch(
    [
      CreatePurchaseOrder,
      CreateReceiptNote,
      CreatePurchaseInvoice,
      DeletePurchaseOrder,
      CompleteReceiptNote
    ],
    to: PurchaseOrder,
    lifespan: PurchaseOrder
  )
end
