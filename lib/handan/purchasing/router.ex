defmodule Handan.Purchasing.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Purchasing.Aggregates.{
    # PurchaseOrder,
    Supplier
  }

  alias Handan.Purchasing.Commands.{
    # CreatePurchaseOrder,
    # DeletePurchaseOrder,
    CreateSupplier,
    DeleteSupplier
    # CreatePurchaseInvoice,
    # ConfirmPurchaseInvoice,
    # CompletePurchaseOrder
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(Supplier, by: :supplier_uuid, prefix: "supplier-")

  dispatch(
    [
      CreateSupplier,
      DeleteSupplier
    ],
    to: Supplier,
    lifespan: Supplier
  )
end
