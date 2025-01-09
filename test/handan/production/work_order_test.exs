defmodule Handan.Production.WorkOrderTest do
  use Handan.DataCase
  @moduledoc false

  alias Handan.Dispatcher
  alias Handan.Production.Projections.WorkOrder

  describe "create work order" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom
    ]

    test "should succeed with valid request", %{has_bom_item: item, warehouse: warehouse} do
      request = %{
        work_order_uuid: Ecto.UUID.generate(),
        item_uuid: item.uuid,
        item_name: item.name,
        bom_uuid: item.default_bom_uuid,
        stock_uom_uuid: item.default_stock_uom_uuid,
        warehouse_uuid: warehouse.uuid,
        planned_qty: 100,
        start_time: DateTime.utc_now(),
        end_time: DateTime.utc_now() |> DateTime.add(86400)
      }

      assert {:ok, %WorkOrder{} = work_order} = Dispatcher.run(request, :create_work_order)

      assert work_order.planned_qty == Decimal.new(request.planned_qty)
      assert length(work_order.items) == 1
      assert length(work_order.material_requests) == 1
    end
  end

  describe "delete work order" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom,
      :create_work_order
    ]

    test "should succeed with valid request", %{work_order: work_order} do
      request = %{
        work_order_uuid: work_order.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_work_order)
    end
  end

  describe "report job card" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom,
      :create_work_order
    ]

    test "should succeed with valid request", %{work_order: work_order} do
      work_order_item = hd(work_order.items)

      request = %{
        work_order_uuid: work_order.uuid,
        job_card_uuid: Ecto.UUID.generate(),
        work_order_item_uuid: work_order_item.uuid,
        operator_staff_uuid: Ecto.UUID.generate(),
        start_time: DateTime.utc_now(),
        end_time: DateTime.utc_now() |> DateTime.add(86400),
        produced_qty: 10,
        defective_qty: 1
      }

      assert {:ok, %WorkOrder{} = update_work_order} = Dispatcher.run(request, :report_job_card)

      assert update_work_order.produced_qty == Decimal.new(request.produced_qty)
      assert update_work_order.scraped_qty == Decimal.new(request.defective_qty)
    end
  end
end
