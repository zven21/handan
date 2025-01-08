defmodule Handan.Production.ProductionPlanTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Production.Projections.ProductionPlan

  describe "create production plan" do
    setup [
      :register_user,
      :create_company,
      :create_item
    ]

    test "should succeed with valid request", %{item: item} do
      request = %{
        production_plan_uuid: Ecto.UUID.generate(),
        title: "production-plan-name",
        start_date: Date.utc_today(),
        end_date: Date.utc_today() |> Date.add(1),
        plan_items: [
          %{
            item_uuid: item.uuid,
            planned_qty: 100
          }
        ]
      }

      assert {:ok, %ProductionPlan{} = production_plan} = Dispatcher.run(request, :create_production_plan)

      assert production_plan.title == request.title
      assert length(production_plan.items) == 1
    end
  end

  describe "delete production plan" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_production_plan
    ]

    test "should succeed with valid request", %{production_plan: production_plan} do
      request = %{
        production_plan_uuid: production_plan.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_production_plan)
      assert {:error, :not_found} == Turbo.get(ProductionPlan, production_plan.uuid)
    end
  end
end
