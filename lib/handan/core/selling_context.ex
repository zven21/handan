defmodule Handan.Core.SellingContext do
  @moduledoc """
  This is the sales module, which needs to display the entire process of customers placing orders, receiving goods, paying or canceling.
  """

  # Customer
  defmodule Customer do
    # Unique identifier for the customer
    defstruct id: nil,
              # Customer name
              name: nil,
              # Phone number for contact
              contact_number: nil,
              # Email address
              email: nil,
              # Customer address
              address: nil,
              # Maximum credit limit
              credit_limit: nil
  end

  # Quotation
  defmodule Quotation do
    # Quotation ID, uniquely identifies each quotation
    defstruct id: nil,
              # Associated customer ID, indicating the quotation object
              customer_id: nil,
              # Quotation validity period, after which the quotation may become invalid
              valid_until: nil,
              # Quotation item list, including products or services involved in the quotation
              items: [],
              # Discount rate, the price discount ratio given to customers
              discount: nil,
              # Delivery date, the promised product delivery time to customers
              delivery_date: nil,
              # Payment terms, such as cash on delivery, prepayment, etc.
              payment_terms: nil
  end

  # Quotation Item
  defmodule QuotationItem do
    # Quotation ID associated with the specific quotation
    defstruct quotation_id: nil,
              # Item name, the name of the product or service in the quotation
              item_name: nil,
              # Item specification, the detailed specification of the product or service
              item_spec: nil,
              # Quantity, the quantity required by the customer
              quantity: nil,
              # Unit price, the original unit price of the product or service
              unit_price: nil,
              # Discounted price, the actual unit price calculated based on the discount rate
              discounted_price: nil,
              # Paid amount, the amount paid by the customer
              paid_amount: nil,
              # Total amount, the total price of the discounted price multiplied by the quantity,
              total_amount: nil
  end

  # Sales Order
  defmodule SalesOrder do
    # Sales Order ID, used to identify each sales transaction
    defstruct id: nil,
              # Associated customer ID, indicating the customer to whom the order belongs
              customer_id: nil,
              # Order date, the time the order was generated
              order_date: nil,
              # Order status, draft, confirmed, to_deliver_and_bill, to_deliver, to_bill, completed, cancelled, closed, etc.
              status: nil,
              # Delivery status, not_delivered, delivered, partially_delivered, fully_delivered
              delivery_status: nil,
              # Billing status, not_billed, billed, partially_billed, fully_billed
              billing_status: nil,
              # Order item list, including details of the products or services purchased
              items: [],
              # Paid amount, the amount paid by the customer
              paid_amount: nil,
              # Remaining amount, the remaining amount to be paid by the customer
              remaining_amount: nil,
              # Total amount of the order, the sum of all item amounts
              total_amount: nil,
              # Delivery date, the time to deliver the product to the customer
              delivery_date: nil
  end

  # Sales Order Item
  defmodule SalesOrderItem do
    # Sales Order ID associated with the specific sales order
    defstruct sales_order_id: nil,
              # Item name, the name of the product or service in the order
              item_name: nil,
              # Item specification, the detailed specification of the product or service
              item_spec: nil,
              # Quantity, the quantity purchased
              ordered_quantity: nil,
              # Delivered quantity, the quantity actually delivered
              delivered_quantity: nil,
              # Pending delivery quantity, the quantity pending delivery
              remaining_quantity: nil,
              # Unit price, the unit price of the product or service
              unit_price: nil,
              # Amount, the total price of the product or service (unit price * quantity)
              amount: nil
  end

  def create_sample_data do
    # Customer
    customer = %Customer{
      id: "C001",
      name: "Beijing Hongyuan Technology Co., Ltd.",
      contact_number: "010 - 12345678",
      email: "hongyuan@example.com",
      address: "XX Street, Chaoyang District, Beijing",
      credit_limit: 100_000
    }

    # Quotation
    quotation = %Quotation{
      id: "Q001",
      customer_id: "C001",
      valid_until: ~D[2024-12-31],
      items: [],
      discount: 0.05,
      delivery_date: ~D[2024-12-10],
      payment_terms: "30% prepayment, balance paid after delivery and inspection"
    }

    # Quotation Item
    quotation_item1 = %QuotationItem{
      quotation_id: "Q001",
      item_name: "Office Package",
      item_spec: "Includes laptop and wireless mouse",
      quantity: 10,
      unit_price: 5100,
      discounted_price: 4845
    }

    quotation = %{quotation | items: [quotation_item1]}

    # Sales Order
    sales_order = %SalesOrder{
      id: "SO001",
      customer_id: "C001",
      order_date: ~D[2024-12-01],
      status: :draft,
      delivery_status: :not_delivered,
      billing_status: :not_billed,
      items: [],
      total_amount: 48450,
      delivery_date: ~D[2024-12-10]
    }

    # Sales Order Item
    sales_order_item1 = %SalesOrderItem{
      sales_order_id: "SO001",
      item_name: "Office Package",
      item_spec: "Includes laptop and wireless mouse",
      ordered_quantity: 10,
      delivered_quantity: 0,
      remaining_quantity: 10,
      unit_price: 4845,
      amount: 48450
    }

    sales_order = %{sales_order | items: [sales_order_item1]}

    %{
      customer: customer,
      quotation: quotation,
      sales_order: sales_order
    }
  end
end
