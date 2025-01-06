defmodule Handan.Core.PurchasingContext do
  @moduledoc """
  This is the purchasing module, which needs to display the entire process of purchasing, including supplier management, quotation management, and order management.
  """

  defmodule Supplier do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            address: String.t(),
            contact: String.t(),
            bank_account: String.t(),
            credit_rating: String.t()
          }

    # Unique identifier for the supplier
    defstruct id: nil,
              # Supplier name
              name: nil,
              # Supplier address
              address: nil,
              # Contact information
              contact: nil,
              # Bank account information
              bank_account: nil,
              # Credit rating
              credit_rating: nil
  end

  defmodule SupplierQuotation do
    @type t :: %__MODULE__{
            id: integer,
            supplier_id: integer,
            date: Date.t(),
            items: [SupplierQuotationItem.t()]
          }

    # Quotation ID, uniquely identifies each quotation
    defstruct id: nil,
              # Supplier ID, indicating the supplier who made the quotation
              supplier_id: nil,
              # Quotation date
              date: nil,
              # Quotation item list
              items: []
  end

  defmodule SupplierQuotationItem do
    @type t :: %__MODULE__{
            id: integer,
            rfq_item_id: integer,
            price: float,
            delivery_time: integer,
            payment_terms: String.t()
          }

    # Quotation ID associated with the specific quotation
    defstruct id: nil,
              # RFQ item ID, indicating the item being quoted
              rfq_item_id: nil,
              # Quoted price
              price: nil,
              # Delivery time
              delivery_time: nil,
              # Payment terms
              payment_terms: nil
  end

  defmodule PurchaseOrder do
    @type t :: %__MODULE__{
            id: integer,
            date: Date.t(),
            status: String.t(),
            delivery_status: String.t(),
            billing_status: String.t(),
            supplier_id: integer,
            items: [PurchaseOrderItem.t()]
          }

    # Purchase Order ID, used to identify each purchase order
    defstruct id: nil,
              # Order date
              date: nil,
              status: nil,
              delivery_status: nil,
              billing_status: nil,
              # Supplier ID, indicating the supplier who received the order
              supplier_id: nil,
              # Order item list
              items: []
  end

  defmodule PurchaseOrderItem do
    @type t :: %__MODULE__{
            id: integer,
            purchase_order_id: integer,
            item_id: integer,
            ordered_quantity: integer,
            received_quantity: integer,
            remaining_quantity: integer,
            price: float,
            total_amount: float
          }

    # Purchase Order ID associated with the specific order
    defstruct id: nil,
              # Item name
              item_id: nil,
              name: nil,
              purchase_order_id: nil,
              # Item specification
              spec: nil,
              # Ordered quantity
              ordered_quantity: nil,
              # Received quantity
              received_quantity: nil,
              # Remaining quantity
              remaining_quantity: nil,
              # Price
              price: nil,
              # Total amount
              total_amount: nil
  end

  def create_sample_data do
    supplier = %Supplier{
      id: "supplier1",
      name: "Sample Supplier",
      address: "123 Supplier St",
      contact: "contact@sample.com",
      bank_account: "1234567890",
      credit_rating: "A"
    }

    sq_item1 = %SupplierQuotationItem{
      id: "sq_item1",
      rfq_item_id: "rfq_item1",
      price: 10.0,
      delivery_time: 10,
      payment_terms: "Net 30"
    }

    supplier_quotation = %SupplierQuotation{
      id: "sq1",
      supplier_id: "supplier1",
      date: Date.new!(2024, 1, 5),
      items: [sq_item1]
    }

    po_item1 = %PurchaseOrderItem{
      id: "po_item1",
      name: "Sample Product",
      spec: "Spec 1",
      ordered_quantity: 100,
      received_quantity: 0,
      remaining_quantity: 100,
      price: 10.0,
      total_amount: 1000.0
    }

    purchase_order = %PurchaseOrder{
      id: "po1",
      date: Date.new!(2024, 1, 10),
      supplier_id: "supplier1",
      items: [po_item1]
    }

    %{
      supplier: supplier,
      supplier_quotation: supplier_quotation,
      purchase_order: purchase_order
    }
  end
end
