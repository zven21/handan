defmodule Handan.Core.ProductionContext do
  @moduledoc false

  defmodule Product do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            spec: String.t(),
            description: String.t()
          }

    # 产品ID
    defstruct id: nil,
              # 产品名称
              name: nil,
              # 产品规格
              spec: nil,
              # 产品描述
              description: nil
  end

  # 物料清单
  defmodule BOM do
    @type t :: %__MODULE__{
            id: integer,
            product_id: integer,
            creator_id: integer,
            items: [BOMItem.t()],
            processs: [BOMProcess.t()]
          }

    defstruct id: nil,
              # 产品ID
              product_id: nil,
              # 创建者ID
              creator_id: nil,
              # 包含的物品列表
              items: [],
              # 包含的操作列表
              processs: []
  end

  defmodule BOMItem do
    @type t :: %__MODULE__{
            id: integer,
            bom_id: integer,
            product_name: String.t(),
            product_spec: String.t(),
            quantity: integer
          }

    defstruct id: nil,
              # 所属物料清单ID
              bom_id: nil,
              # 物品名称
              product_name: nil,
              # 物品规格
              product_spec: nil,
              # 数量
              quantity: nil
  end

  # 工序
  defmodule Process do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            code: String.t(),
            description: String.t()
          }

    defstruct id: nil,
              # 操作名称
              name: nil,
              # 操作代码
              code: nil,
              # 操作描述
              description: nil
  end

  defmodule BOMProcess do
    @type t :: %__MODULE__{
            id: integer,
            bom_id: integer,
            process_name: String.t(),
            description: String.t(),
            position: String.t(),
            tool_required: String.t(),
            sequence: integer,
            workstation_id: integer
          }

    defstruct id: nil,
              # 所属物料清单ID
              bom_id: nil,
              # 工序名称
              process_name: nil,
              # 操作描述
              description: nil,
              # 操作位置
              position: nil,
              # 所需工具
              tool_required: nil,
              # 操作顺序
              sequence: nil,
              # 工作站ID
              workstation_id: nil
  end

  defmodule ProductionPlanMaterialRequest do
    @type t :: %__MODULE__{
            id: integer,
            production_plan_id: integer,
            items: [ProductionPlanMaterialRequestItem.t()]
          }

    defstruct id: nil,
              # 所属生产计划ID
              production_plan_id: nil,
              # 包含的物料需求计划物品列表
              items: []
  end

  # 生产计划
  defmodule ProductionPlan do
    @type t :: %__MODULE__{
            id: integer,
            start_date: Date.t(),
            end_date: Date.t(),
            items: [ProductionPlanItem.t()],
            material_requests: [ProductionPlanMaterialRequest.t()]
          }

    defstruct id: nil,
              # 计划开始日期
              start_date: nil,
              # 计划结束日期
              end_date: nil,
              # 包含的生产计划物品列表
              items: [],
              # 物料需求列表
              material_requests: []
  end

  defmodule ProductionPlanItem do
    @type t :: %__MODULE__{
            id: integer,
            production_plan_id: integer,
            product_name: String.t(),
            product_spec: String.t(),
            planned_quantity: integer,
            start_time: DateTime.t(),
            end_time: DateTime.t()
          }

    defstruct id: nil,
              # 所属生产计划ID
              production_plan_id: nil,
              # 产品名称
              product_name: nil,
              # 产品规格
              product_spec: nil,
              # 计划数量
              planned_quantity: nil,
              # 计划开始时间
              start_time: nil,
              # 计划结束时间
              end_time: nil
  end

  defmodule WorkOrder do
    @type t :: %__MODULE__{
            id: integer,
            production_plan_item_id: integer,
            status: String.t(),
            start_time: DateTime.t(),
            end_time: DateTime.t(),
            items: [WorkOrderItem.t()],
            processes: [Process.t()]
          }

    defstruct id: nil,
              # 所属生产计划物品ID
              production_plan_item_id: nil,
              # 工作订单状态
              status: nil,
              # 工作订单开始时间
              start_time: nil,
              # 工作订单结束时间
              end_time: nil,
              # 工作订单包含的物品列表
              items: [],
              # 工作订单包含的工序列表
              processes: []
  end

  defmodule WorkOrderItem do
    @type t :: %__MODULE__{
            id: integer,
            work_order_id: integer,
            process_id: integer,
            product_name: String.t(),
            product_spec: String.t(),
            required_qty: integer,
            returned_qty: integer
          }

    defstruct id: nil,
              # 所属工作订单ID
              work_order_id: nil,
              # 工序 ID
              process_id: nil,
              # 物品名称
              product_name: nil,
              # 物品规格
              product_spec: nil,
              # 数量
              required_qty: nil,
              returned_qty: nil
  end

  defmodule JobCard do
    @type t :: %__MODULE__{
            id: integer,
            work_order_item_id: integer,
            status: String.t(),
            start_time: DateTime.t(),
            end_time: DateTime.t(),
            production_qty: integer,
            defective_qty: integer
          }

    defstruct id: nil,
              # 所属工作订单ID
              work_order_item_id: nil,
              # 作业卡状态
              status: nil,
              # 作业卡开始时间
              start_time: nil,
              # 作业卡结束时间
              end_time: nil,
              # 作业卡生产数量
              production_qty: nil,
              # 不合格的数量
              defective_qty: nil
  end

  # 工作站
  defmodule Workstation do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            plant_floor_id: integer,
            workstation_type_id: integer,
            equipment: [String.t()]
          }

    defstruct id: nil,
              # 工作站名称
              name: nil,
              # 所属车间ID
              plant_floor_id: nil,
              # 工作站类型ID
              workstation_type_id: nil,
              # 包含的设备列表
              equipment: []
  end

  # 车间
  defmodule PlantFloor do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            location: String.t(),
            area: integer,
            department: String.t(),
            equipment_layout: String.t(),
            staff_allocation: [String.t()]
          }

    defstruct id: nil,
              # 车间名称
              name: nil,
              # 车间位置
              location: nil,
              # 车间面积
              area: nil,
              # 所属部门
              department: nil,
              # 设备布局
              equipment_layout: nil,
              # 人员分配
              staff_allocation: []
  end

  def create_sample_data do
    # 产品：实木餐桌
    product = %Product{
      id: 1,
      name: "实木餐桌",
      spec: "长 180cm，宽 90cm，高 75cm，带 4 根雕花桌腿",
      description: "一款优雅的实木餐桌，适合家庭聚餐等场合使用。"
    }

    # 物料清单（BOM）
    table_top_item = %BOMItem{
      id: 1,
      bom_id: 1,
      product_name: "桌面",
      product_spec: "180cm×90cm×5cm 实木板材",
      quantity: 1
    }

    table_leg_item = %BOMItem{
      id: 2,
      bom_id: 1,
      product_name: "桌腿",
      product_spec: "高 70cm，直径 10cm 雕花木柱",
      quantity: 4
    }

    varnish_item = %BOMItem{
      id: 3,
      bom_id: 1,
      product_name: "清漆",
      product_spec: "5L 环保清漆",
      quantity: 2
    }

    cutting_process = %BOMProcess{
      id: 1,
      bom_id: 1,
      process_name: "木材切割",
      description: "将实木板材精准切割成桌面所需尺寸。",
      position: "木工车间 1 区",
      tool_required: "精密锯床",
      sequence: 1,
      workstation_id: 1
    }

    carving_process = %BOMProcess{
      id: 2,
      bom_id: 1,
      process_name: "桌腿雕花",
      description: "将桌腿雕刻成带有精美图案的圆柱造型。",
      position: "木工车间 2 区",
      tool_required: "雕刻机",
      sequence: 2,
      workstation_id: 2
    }

    varnishing_process = %BOMProcess{
      id: 3,
      bom_id: 1,
      process_name: "上漆工序",
      description: "将清漆均匀涂抹在桌面和桌腿上，起到保护和美观的作用。",
      position: "涂装车间",
      tool_required: "喷枪",
      sequence: 3,
      workstation_id: 3
    }

    bom = %BOM{
      id: 1,
      product_id: 1,
      creator_id: 1,
      items: [table_top_item, table_leg_item, varnish_item],
      processs: [cutting_process, carving_process, varnishing_process]
    }

    # 生产计划
    production_plan_item = %ProductionPlanItem{
      id: 1,
      production_plan_id: 1,
      product_name: "实木餐桌",
      product_spec: "长 180cm，宽 90cm，高 75cm，在 4 根雕花桌腿",
      planned_quantity: 20,
      start_time: DateTime.utc_now(),
      # 假设 7 天后完成
      end_time: DateTime.utc_now() |> DateTime.add(3600 * 24 * 7)
    }

    production_plan = %ProductionPlan{
      id: 1,
      start_date: Date.utc_today(),
      end_date: Date.utc_today() |> Date.add(7),
      items: [production_plan_item],
      material_requests: []
    }

    # 生成物料需求
    material_request =
      [production_plan_item]
      |> Enum.map(fn item ->
        bom.items
        |> Enum.map(fn bom_item ->
          %{
            id: bom_item.id,
            production_plan_id: production_plan.id,
            product_name: bom_item.product_name,
            product_spec: bom_item.product_spec,
            quantity: bom_item.quantity * item.planned_quantity
          }
        end)
      end)
      |> List.flatten()
      |> Enum.reduce(
        %ProductionPlanMaterialRequest{
          id: 1,
          production_plan_id: production_plan.id,
          items: []
        },
        fn item, acc ->
          %ProductionPlanMaterialRequest{
            acc
            | items: [item | acc.items]
          }
        end
      )

    updated_production_plan = %ProductionPlan{
      production_plan
      | material_requests: material_request
    }

    # 工作订单
    work_order_item_1 = %WorkOrderItem{
      id: 1,
      work_order_id: 1,
      process_id: 1,
      product_name: "桌面",
      product_spec: "180cm×90cm×5cm 实木板材",
      required_qty: 20,
      returned_qty: 0
    }

    work_order_item_2 = %WorkOrderItem{
      id: 2,
      work_order_id: 1,
      process_id: 2,
      product_name: "桌腿",
      product_spec: "高 70cm，直径 10cm 雕花木柱",
      required_qty: 80,
      returned_qty: 0
    }

    work_order_item_3 = %WorkOrderItem{
      id: 3,
      work_order_id: 1,
      process_id: 3,
      product_name: "清漆",
      product_spec: "5L 环保清漆",
      required_qty: 2,
      returned_qty: 0
    }

    work_order = %WorkOrder{
      id: 1,
      production_plan_item_id: 1,
      status: "已下达",
      start_time: DateTime.utc_now(),
      end_time: DateTime.utc_now() |> DateTime.add(3600 * 24 * 7),
      items: [work_order_item_1, work_order_item_2, work_order_item_3],
      processes: [cutting_process, carving_process, varnishing_process]
    }

    # 作业卡
    job_card = %JobCard{
      id: 1,
      work_order_item_id: 1,
      status: "执行中",
      start_time: DateTime.utc_now(),
      end_time: DateTime.utc_now() |> DateTime.add(3600 * 24 * 7),
      production_qty: 0,
      defective_qty: 0
    }

    %{
      product: product,
      bom: bom,
      production_plan: updated_production_plan,
      work_order: work_order,
      job_card: job_card
    }
  end
end
