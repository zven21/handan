defmodule HandanWeb.GraphQL.Resolvers.Purchasing do
  @moduledoc false

  alias Handan.Purchasing
  alias Handan.Dispatcher

  @doc "get supplier"
  def get_supplier(%{request: %{uuid: uuid}}, _), do: Purchasing.get_supplier(uuid)

  @doc "list suppliers"
  def list_suppliers(_, _), do: Purchasing.list_suppliers()

  @doc "get purchase order item"
  def get_purchase_order_item(%{request: %{uuid: uuid}}, _), do: Purchasing.get_purchase_order_item(uuid)

  @doc "get purchase order"
  def get_purchase_order(%{request: %{purchase_order_uuid: uuid}}, _), do: Purchasing.get_purchase_order(uuid)

  @doc "list purchase orders"
  def list_purchase_orders(_, _), do: Purchasing.list_purchase_orders()

  @doc "get purchase invoice"
  def get_purchase_invoice(%{request: %{purchase_invoice_uuid: uuid}}, _), do: Purchasing.get_purchase_invoice(uuid)

  @doc "list purchase invoices"
  def list_purchase_invoices(_, _), do: Purchasing.list_purchase_invoices()

  @doc "get receipt note"
  def get_receipt_note(%{request: %{receipt_note_uuid: uuid}}, _), do: Purchasing.get_receipt_note(uuid)

  @doc "list receipt notes"
  def list_receipt_notes(_, _), do: Purchasing.list_receipt_notes()

  def create_supplier(_, %{request: request}, _) do
    request
    |> Map.put(:supplier_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_supplier)
  end

  @doc "create purchase order"
  def create_purchase_order(_, %{request: request}, _) do
    request
    |> Map.put(:purchase_order_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_purchase_order)
  end

  @doc "confirm purchase order"
  def confirm_purchase_order(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:confirm_purchase_order)
  end

  @doc "create purchase invoice"
  def create_purchase_invoice(_, %{request: request}, _) do
    request
    |> Map.put(:purchase_invoice_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_purchase_invoice)
  end

  @doc "confirm purchase invoice"
  def confirm_purchase_invoice(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:confirm_purchase_invoice)
  end

  @doc "create receipt note"
  def create_receipt_note(_, %{request: request}, _) do
    request
    |> Map.put(:receipt_note_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_receipt_note)
  end

  @doc "confirm receipt note"
  def confirm_receipt_note(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:confirm_receipt_note)
  end

  @doc "complete receipt note"
  def complete_receipt_note(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:complete_receipt_note)
  end
end
