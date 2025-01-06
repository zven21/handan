defmodule Handan.SellingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Handan.Selling` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        address: "some address",
        balance: "120.5",
        name: "some name"
      })
      |> Handan.Selling.create_customer()

    customer
  end

  @doc """
  Generate a sales_order.
  """
  def sales_order_fixture(attrs \\ %{}) do
    {:ok, sales_order} =
      attrs
      |> Enum.into(%{
        billing_status: "some billing_status",
        customer_name: "some customer_name",
        customer_uuid: "some customer_uuid",
        delivery_status: "some delivery_status",
        status: "some status",
        total_amount: "120.5"
      })
      |> Handan.Selling.create_sales_order()

    sales_order
  end

  @doc """
  Generate a sales_order_item.
  """
  def sales_order_item_fixture(attrs \\ %{}) do
    {:ok, sales_order_item} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        item_name: "some item_name",
        item_uuid: "some item_uuid",
        ordered_qty: 42,
        sales_order_uuid: "some sales_order_uuid",
        unit_price: "120.5"
      })
      |> Handan.Selling.create_sales_order_item()

    sales_order_item
  end

  @doc """
  Generate a sales_invoice.
  """
  def sales_invoice_fixture(attrs \\ %{}) do
    {:ok, sales_invoice} =
      attrs
      |> Enum.into(%{
        customer_name: "some customer_name",
        customer_uuid: "some customer_uuid",
        sales_order_uuid: "some sales_order_uuid",
        status: "some status",
        total_amount: "120.5"
      })
      |> Handan.Selling.create_sales_invoice()

    sales_invoice
  end

  @doc """
  Generate a delivery_note.
  """
  def delivery_note_fixture(attrs \\ %{}) do
    {:ok, delivery_note} =
      attrs
      |> Enum.into(%{
        customer_name: "some customer_name",
        customer_uuid: "some customer_uuid",
        sales_order_uuid: "some sales_order_uuid",
        total_qty: "120.5"
      })
      |> Handan.Selling.create_delivery_note()

    delivery_note
  end

  @doc """
  Generate a delivery_note_item.
  """
  def delivery_note_item_fixture(attrs \\ %{}) do
    {:ok, delivery_note_item} =
      attrs
      |> Enum.into(%{
        delivery_note_uuid: "some delivery_note_uuid",
        item_name: "some item_name",
        item_uuid: "some item_uuid",
        qty: "120.5",
        sales_order_uuid: "some sales_order_uuid"
      })
      |> Handan.Selling.create_delivery_note_item()

    delivery_note_item
  end
end
