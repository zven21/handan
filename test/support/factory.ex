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

  def workstation_factory() do
    %{
      workstation_uuid: Ecto.UUID.generate(),
      name: sequence(:name, &"name-#{&1}")
    }
  end

  def production_plan_factory() do
    %{
      production_plan_uuid: Ecto.UUID.generate(),
      title: sequence(:title, &"title-#{&1}")
    }
  end

  def payment_method_factory() do
    %{
      payment_method_uuid: Ecto.UUID.generate(),
      name: sequence(:name, &"name-#{&1}")
    }
  end

  def work_order_factory() do
    %{
      work_order_uuid: Ecto.UUID.generate()
    }
  end

  def report_job_card_factory() do
    %{
      job_card_uuid: Ecto.UUID.generate(),
      work_order_uuid: Ecto.UUID.generate(),
      work_order_item_uuid: Ecto.UUID.generate(),
      operator_staff_uuid: Ecto.UUID.generate(),
      start_time: DateTime.utc_now(),
      end_time: DateTime.utc_now() |> DateTime.add(86400),
      produced_qty: 10,
      defective_qty: 1
    }
  end

  def payment_entry_factory() do
    %{
      payment_entry_uuid: Ecto.UUID.generate()
    }
  end
end
