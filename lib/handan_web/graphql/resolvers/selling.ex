defmodule HandanWeb.GraphQL.Resolvers.Selling do
  @moduledoc false
  alias Handan.Selling
  alias Handan.Dispatcher

  @doc "get customer"
  def get_customer(%{request: %{uuid: uuid}}, _), do: Selling.get_customer(uuid)

  @doc "list customers"
  def get_customers(_, _), do: Selling.list_customers()

  @doc "get sales order"
  def get_sales_order(%{request: %{sales_order_uuid: uuid}}, _), do: Selling.get_sales_order(uuid)

  @doc "list sales orders"
  def list_sales_orders(_, _), do: Selling.list_sales_orders()

  @doc "get delivery note"
  def get_delivery_note(%{request: %{delivery_note_uuid: uuid}}, _), do: Selling.get_delivery_note(uuid)

  @doc "list delivery notes"
  def list_delivery_notes(_, _), do: Selling.list_delivery_notes()

  @doc "get sales invoice"
  def get_sales_invoice(%{request: %{sales_invoice_uuid: uuid}}, _), do: Selling.get_sales_invoice(uuid)

  @doc "list sales invoices"
  def list_sales_invoices(_, _), do: Selling.list_sales_invoices()

  @doc "create customer"
  def create_customer(_, %{request: request}, _) do
    request
    |> Map.put(:customer_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_customer)
  end

  @doc "create sales order"
  def create_sales_order(_, %{request: request}, _) do
    request
    |> Map.put(:sales_order_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_sales_order)
  end

  @doc "confirm sales order"
  def confirm_sales_order(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:confirm_sales_order)
  end

  @doc "create sales invoice"
  def create_sales_invoice(_, %{request: request}, _) do
    request
    |> Map.put(:sales_invoice_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_sales_invoice)
  end

  @doc "confirm sales invoice"
  def confirm_sales_invoice(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:confirm_sales_invoice)
  end

  @doc "create delivery note"
  def create_delivery_note(_, %{request: request}, _) do
    request
    |> Map.put(:delivery_note_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_delivery_note)
  end

  @doc "confirm delivery note"
  def confirm_delivery_note(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:confirm_delivery_note)
  end
end
