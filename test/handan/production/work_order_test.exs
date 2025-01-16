defmodule Handan.Production.WorkOrderTest do
  use Handan.DataCase
  @moduledoc false

  import Handan.Infrastructure.DecimalHelper, only: [decimal_add: 2]

  alias Handan.Dispatcher
  alias Handan.Turbo
  alias Handan.Production.Projections.WorkOrder
  alias Handan.Stock.Projections.StockItem

  describe "create work order" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom
    ]

    test "should succeed with valid request", %{bom: bom, warehouse: warehouse} do
      request = %{
        work_order_uuid: Ecto.UUID.generate(),
        bom_uuid: bom.uuid,
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

  describe "schedule work order" do
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

      assert {:ok, %WorkOrder{} = update_work_order} = Dispatcher.run(request, :schedule_work_order)

      assert update_work_order.status == :scheduling
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

  describe "store finish item" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom,
      :create_work_order
    ]

    test "should fail with invalid request", %{work_order: work_order} do
      request = %{
        work_order_uuid: work_order.uuid,
        stored_qty: 10
      }

      assert {:error, :no_enough_stock} = Dispatcher.run(request, :store_finish_item)
    end
  end

  describe "store finish item with enough stock" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom,
      :create_work_order,
      :report_job_card
    ]

    test "should fail with invalid request", %{work_order: work_order} do
      request = %{
        work_order_uuid: work_order.uuid,
        stored_qty: 10
      }

      assert {:ok, before_stock_item} = Turbo.get_by(StockItem, %{warehouse_uuid: work_order.warehouse_uuid, item_uuid: work_order.item_uuid})
      assert {:ok, %WorkOrder{} = update_work_order} = Dispatcher.run(request, :store_finish_item)
      assert {:ok, after_stock_item} = Turbo.get_by(StockItem, %{warehouse_uuid: work_order.warehouse_uuid, item_uuid: work_order.item_uuid})

      assert update_work_order.stored_qty == Decimal.new(request.stored_qty)
      assert after_stock_item.total_on_hand == decimal_add(before_stock_item.total_on_hand, request.stored_qty)
    end
  end
end
