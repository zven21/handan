defmodule HandanWeb.GraphQL.Resolvers.Selling do
  @moduledoc false
  alias Handan.Selling
  alias Handan.Dispatcher

  @doc "get customer"
  def get_customer(%{request: %{uuid: uuid}}, _) do
    {:ok, Selling.get_customer(uuid)}
  end

  @doc "list customers"
  def get_customers(_, _) do
    {:ok, Selling.list_customers()}
  end

  @doc "get sales order"
  def get_sales_order(%{request: %{uuid: uuid}}, _) do
    {:ok, Selling.get_sales_order(uuid)}
  end

  @doc "list sales orders"
  def get_sales_orders(_, _) do
    {:ok, Selling.list_sales_orders()}
  end

  @doc "create sales order"
  def create_sales_order(%{request: request}, _) do
    Dispatcher.run(request, :create_sales_order)
  end

  @doc "submit sales order"
  def submit_sales_order(%{request: request}, _) do
    Dispatcher.run(request, :submit_sales_order)
  end

  @doc "create sales invoice"
  def create_sales_invoice(%{request: request}, _) do
    Dispatcher.run(request, :create_sales_invoice)
  end

  @doc "submit sales invoice"
  def submit_sales_invoice(%{request: request}, _) do
    Dispatcher.run(request, :submit_sales_invoice)
  end

  @doc "create delivery note"
  def create_delivery_note(%{request: request}, _) do
    Dispatcher.run(request, :create_delivery_note)
  end

  @doc "submit delivery note"
  def submit_delivery_note(%{request: request}, _) do
    Dispatcher.run(request, :submit_delivery_note)
  end
end
