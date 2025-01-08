defmodule Handan.Production.Aggregates.ProductionPlan do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :production_plan_uuid, Ecto.UUID
    field :title, :string
    field :start_date, :date
    field :end_date, :date
    field :status, :string
    field :material_request_uuid, Ecto.UUID

    # 生产计划项
    field :plan_items, :map, default: %{}
    field :material_request_items, :map, default: %{}

    field :deleted?, :boolean, default: false
  end

  alias Handan.Production.Commands.{
    CreateProductionPlan,
    DeleteProductionPlan
  }

  alias Handan.Production.Events.{
    ProductionPlanCreated,
    ProductionPlanDeleted,
    ProductionPlanItemAdded,
    MaterialRequestCreated,
    MaterialRequestItemAdded
  }

  @doc """
  停止已删除的聚合
  """
  def after_event(%ProductionPlanDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # 创建生产计划
  def execute(%__MODULE__{production_plan_uuid: nil}, %CreateProductionPlan{} = cmd) do
    production_plan_evt = %ProductionPlanCreated{
      production_plan_uuid: cmd.production_plan_uuid,
      title: cmd.title,
      status: :draft,
      start_date: cmd.start_date,
      end_date: cmd.end_date
    }

    plan_items_evt =
      cmd.plan_items
      |> Enum.map(fn item ->
        %ProductionPlanItemAdded{
          production_plan_item_uuid: item.production_plan_item_uuid,
          production_plan_uuid: cmd.production_plan_uuid,
          item_uuid: item.item_uuid,
          item_name: item.item_name,
          planned_qty: item.planned_qty
        }
      end)

    material_request_evts =
      if length(cmd.material_request_items) > 0 do
        material_request_uuid = Ecto.UUID.generate()

        material_request_evt =
          %MaterialRequestCreated{
            production_plan_uuid: cmd.production_plan_uuid,
            material_request_uuid: material_request_uuid
          }

        material_request_items_evt =
          cmd.material_request_items
          |> Enum.map(fn item ->
            %MaterialRequestItemAdded{
              material_request_item_uuid: item.material_request_item_uuid,
              material_request_uuid: material_request_uuid,
              item_uuid: item.item_uuid,
              item_name: item.item_name,
              stock_uom_uuid: item.stock_uom_uuid,
              uom_name: item.uom_name,
              actual_qty: item.actual_qty
            }
          end)

        [material_request_evt, material_request_items_evt]
      else
        []
      end

    [production_plan_evt, plan_items_evt, material_request_evts] |> List.flatten()
  end

  def execute(_, %CreateProductionPlan{}), do: {:error, :not_allowed}

  # 删除生产计划
  def execute(%__MODULE__{production_plan_uuid: production_plan_uuid} = _state, %DeleteProductionPlan{production_plan_uuid: production_plan_uuid} = _cmd) do
    production_plan_deleted_evt = %ProductionPlanDeleted{
      production_plan_uuid: production_plan_uuid
    }

    [production_plan_deleted_evt]
  end

  def execute(_, %DeleteProductionPlan{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %ProductionPlanCreated{} = evt) do
    %__MODULE__{
      state
      | production_plan_uuid: evt.production_plan_uuid,
        title: evt.title,
        status: evt.status,
        start_date: evt.start_date,
        end_date: evt.end_date
    }
  end

  def apply(%__MODULE__{} = state, %ProductionPlanDeleted{}) do
    %__MODULE__{state | deleted?: true}
  end

  def apply(%__MODULE__{} = state, %ProductionPlanItemAdded{} = evt) do
    updated_plan_items =
      state.plan_items
      |> Map.put(evt.production_plan_item_uuid, evt)

    %__MODULE__{
      state
      | plan_items: updated_plan_items
    }
  end

  def apply(%__MODULE__{} = state, %MaterialRequestCreated{} = evt) do
    %__MODULE__{
      state
      | material_request_uuid: evt.material_request_uuid
    }
  end

  def apply(%__MODULE__{} = state, %MaterialRequestItemAdded{} = evt) do
    updated_material_request_items =
      state.material_request_items
      |> Map.put(evt.material_request_item_uuid, evt)

    %__MODULE__{
      state
      | material_request_items: updated_material_request_items
    }
  end
end
