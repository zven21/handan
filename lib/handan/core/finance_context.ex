defmodule Handan.Core.FinanceContext do
  @moduledoc """
  finance mvp
  """

  # 客户
  defmodule Customer do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            contact_number: String.t(),
            email: String.t(),
            address: String.t()
          }

    defstruct id: nil,
              name: nil,
              contact_number: nil,
              email: nil,
              address: nil
  end

  # 供应商
  defmodule Supplier do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            address: String.t(),
            contact: String.t()
          }

    defstruct id: nil,
              name: nil,
              address: nil,
              contact: nil
  end

  # 销售发票
  defmodule SalesInvoice do
    @type t :: %__MODULE__{
            id: integer,
            customer_id: integer,
            invoice_date: Date.t(),
            total_amount: float
          }

    defstruct id: nil,
              customer_id: nil,
              invoice_date: nil,
              total_amount: nil
  end

  # 采购发票
  defmodule PurchaseInvoice do
    @type t :: %__MODULE__{
            id: integer,
            supplier_id: integer,
            invoice_date: Date.t(),
            total_amount: float
          }

    defstruct id: nil,
              supplier_id: nil,
              invoice_date: nil,
              total_amount: nil
  end

  # 交易记录，包括销售和采购的支付记录
  defmodule PaymentEntry do
    @type t :: %__MODULE__{
            id: integer,
            invoice_id: integer,
            payment_date: Date.t(),
            amount: float,
            party_id: integer,
            party_type: String.t(),
            party_name: String.t(),
            payment_method_id: integer,
            payment_method_name: String.t(),
            purchase_invoice_ids: [integer],
            sales_invoice_ids: [integer]
          }

    defstruct id: nil,
              invoice_id: nil,
              payment_date: nil,
              amount: nil,
              party_id: nil,
              party_type: nil,
              party_name: nil,
              payment_method_id: nil,
              payment_method_name: nil,
              purchase_invoice_ids: [],
              sales_invoice_ids: []
  end

  # 交易方式(现金、银行转账、信用卡、支付宝、微信支付等)
  defmodule PaymentMethod do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t()
          }

    defstruct id: nil,
              name: nil
  end

  def create_sample_data do
    # 创建交易方式
    cash_method = %PaymentMethod{
      id: 1,
      name: "现金"
    }

    bank_transfer_method = %PaymentMethod{
      id: 2,
      name: "银行转账"
    }

    # 创建客户
    customer1 = %Customer{
      id: 1,
      name: "北京家具城",
      contact_number: "123 - 4567 - 8900",
      email: "beijing_furniture@example.com",
      address: "北京市朝阳区 XX 大街 XX 号"
    }

    customer2 = %Customer{
      id: 2,
      name: "上海家居广场",
      contact_number: "234 - 5678 - 9011",
      email: "shanghai_home@example.com",
      address: "上海市浦东新区 XX 路 XX 号"
    }

    # 创建供应商
    supplier1 = %Supplier{
      id: 1,
      name: "东北木材厂",
      address: "黑龙江省 XX 市 XX 区",
      contact: "李老板，135 - 7924 - 6800"
    }

    supplier2 = %Supplier{
      id: 2,
      name: "南方油漆厂",
      address: "广东省 XX 市 XX 区",
      contact: "王经理，246 - 8135 - 7900"
    }

    # 创建销售发票
    sales_invoice1 = %SalesInvoice{
      id: 1,
      customer_id: 1,
      invoice_date: Date.utc_today(),
      total_amount: 5000.0
    }

    sales_invoice2 = %SalesInvoice{
      id: 2,
      customer_id: 2,
      invoice_date: Date.utc_today() |> Date.add(1),
      total_amount: 3000.0
    }

    # 创建采购发票
    purchase_invoice1 = %PurchaseInvoice{
      id: 1,
      supplier_id: 1,
      invoice_date: Date.utc_today(),
      total_amount: 2000.0
    }

    purchase_invoice2 = %PurchaseInvoice{
      id: 2,
      supplier_id: 2,
      invoice_date: Date.utc_today() |> Date.add(1),
      total_amount: 1500.0
    }

    # 创建交易记录
    payment_entry1 = %PaymentEntry{
      id: 1,
      invoice_id: 1,
      payment_date: Date.utc_today() |> Date.add(5),
      amount: 5000.0,
      party_id: 1,
      party_type: "Customer",
      party_name: "北京家具城",
      payment_method_id: 1,
      payment_method_name: "现金",
      sales_invoice_ids: [1]
    }

    payment_entry2 = %PaymentEntry{
      id: 2,
      invoice_id: 2,
      payment_date: Date.utc_today() |> Date.add(6),
      amount: 3000.0,
      party_id: 2,
      party_type: "Customer",
      party_name: "上海家居广场",
      payment_method_id: 2,
      payment_method_name: "银行转账",
      sales_invoice_ids: [2]
    }

    payment_entry3 = %PaymentEntry{
      id: 3,
      invoice_id: 1,
      payment_date: Date.utc_today() |> Date.add(7),
      amount: 2000.0,
      party_id: 1,
      party_type: "Supplier",
      party_name: "东北木材厂",
      payment_method_id: 2,
      payment_method_name: "银行转账",
      purchase_invoice_ids: [1]
    }

    %{
      cash_method: cash_method,
      bank_transfer_method: bank_transfer_method,
      customer1: customer1,
      customer2: customer2,
      supplier1: supplier1,
      supplier2: supplier2,
      sales_invoice1: sales_invoice1,
      sales_invoice2: sales_invoice2,
      purchase_invoice1: purchase_invoice1,
      purchase_invoice2: purchase_invoice2,
      payment_entry1: payment_entry1,
      payment_entry2: payment_entry2,
      payment_entry3: payment_entry3
    }
  end
end
