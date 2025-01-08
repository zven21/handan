defmodule Handan.Factory do
  @moduledoc false

  use ExMachina

  def user_factory() do
    %{
      user_uuid: Ecto.UUID.generate(),
      email: sequence(:email, &"user-#{&1}@example.com"),
      nickname: sequence(:nickname, &"user-#{&1}"),
      password: "123"
    }
  end

  def company_factory(%{user_uuid: user_uuid}) do
    %{
      company_uuid: Ecto.UUID.generate(),
      user_uuid: user_uuid,
      name: sequence(:name, &"name-#{&1}"),
      description: sequence(:description, &"description-#{&1}")
    }
  end

  def item_factory() do
    %{
      item_uuid: Ecto.UUID.generate(),
      selling_price: 100.0,
      name: sequence(:name, &"name-#{&1}"),
      description: sequence(:description, &"description-#{&1}")
    }
  end

  def customer_factory() do
    %{
      customer_uuid: Ecto.UUID.generate(),
      name: sequence(:name, &"name-#{&1}"),
      address: sequence(:address, &"address-#{&1}")
    }
  end

  def supplier_factory() do
    %{
      supplier_uuid: Ecto.UUID.generate(),
      name: sequence(:name, &"name-#{&1}"),
      address: sequence(:address, &"address-#{&1}")
    }
  end

  def sales_order_factory() do
    %{
      sales_order_uuid: Ecto.UUID.generate(),
      customer_uuid: Ecto.UUID.generate(),
      warehouse_uuid: Ecto.UUID.generate()
    }
  end

  def delivery_note_factory() do
    %{
      delivery_note_uuid: Ecto.UUID.generate(),
      sales_order_uuid: Ecto.UUID.generate()
    }
  end

  def sales_invoice_factory() do
    %{
      sales_invoice_uuid: Ecto.UUID.generate(),
      sales_order_uuid: Ecto.UUID.generate()
    }
  end

  def purchase_order_factory() do
    %{
      purchase_order_uuid: Ecto.UUID.generate(),
      supplier_uuid: Ecto.UUID.generate()
    }
  end

  def receipt_note_factory() do
    %{
      receipt_note_uuid: Ecto.UUID.generate(),
      purchase_order_uuid: Ecto.UUID.generate()
    }
  end

  def purchase_invoice_factory() do
    %{
      purchase_invoice_uuid: Ecto.UUID.generate(),
      purchase_order_uuid: Ecto.UUID.generate()
    }
  end

  def bom_factory() do
    %{
      bom_uuid: Ecto.UUID.generate(),
      name: sequence(:name, &"name-#{&1}"),
      item_uuid: Ecto.UUID.generate()
    }
  end

  def process_factory() do
    %{
      process_uuid: Ecto.UUID.generate(),
      name: sequence(:name, &"name-#{&1}"),
      description: sequence(:description, &"description-#{&1}")
    }
  end
end
