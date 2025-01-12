defmodule HandanWeb.GraphQL.Schemas.Production do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias Handan.Production

  object :work_order do
    field :uuid, :id
    field :title, :string
    field :start_time, :datetime
    field :end_time, :datetime
    field :type, :string
    field :status, :string
    field :planned_qty, :decimal
    field :stored_qty, :decimal
    field :produced_qty, :decimal
    field :scraped_qty, :decimal
    field :item_uuid, :id
    field :item_name, :string
    field :uom_name, :string
    field :supplier_name, :string
    field :supplier_uuid, :id
    field :sales_order_uuid, :id
    field :stock_uom_uuid, :id

    # field :supplier, :supplier, resolve: dataloader(Production, :supplier)
    field :bom, :bom, resolve: dataloader(Production, :bom)
    field :warehouse, :warehouse, resolve: dataloader(Production, :warehouse)
    field :item, :item, resolve: dataloader(Production, :item)
    field :items, list_of(:work_order_item), resolve: dataloader(Production, :items)
    field :material_requests, list_of(:work_order_material_request), resolve: dataloader(Production, :material_requests)
  end

  object :work_order_item do
    field :uuid, :id
    field :item_name, :string
    field :process_name, :string
    field :position, :integer
    field :required_qty, :decimal
    field :defective_qty, :decimal
    field :produced_qty, :decimal
  end

  object :bom do
    field :uuid, :id
    field :name, :string
    field :item_name, :string
    field :item, :item, resolve: dataloader(Production, :item)
    field :bom_items, list_of(:bom_item), resolve: dataloader(Production, :bom_items)
    field :bom_processes, list_of(:bom_process), resolve: dataloader(Production, :bom_processes)
  end

  object :bom_item do
    field :uuid, :id
    field :item_name, :string
    field :qty, :integer
    field :uom_name, :string
    field :stock_uom_uuid, :id
    field :bom, :bom, resolve: dataloader(Production, :bom)
    field :item, :item, resolve: dataloader(Production, :item)
    field :stock_uom, :stock_uom, resolve: dataloader(Production, :stock_uom)
  end

  object :bom_process do
    field :position, :integer
    field :process_name, :string
    field :tool_required, :string
    field :bom, :bom, resolve: dataloader(Production, :bom)
    field :process, :process, resolve: dataloader(Production, :process)
  end

  object :process do
    field :uuid, :id
    field :code, :string
    field :description, :string
    field :name, :string
  end

  object :job_card do
    field :start_time, :datetime
    field :end_time, :datetime
    field :status, :string
    field :operator_staff_uuid, :id
    field :defective_qty, :decimal
    field :produced_qty, :decimal
  end

  object :workstation do
    field :uuid, :id
    field :name, :string
    field :admin_uuid, :string
    field :members, list_of(:staff), resolve: dataloader(Production, :members)
  end

  object :work_order_material_request do
    field :item_name, :string
    field :actual_qty, :decimal
    field :remaining_qty, :decimal
    field :received_qty, :decimal
    field :uom_name, :string
    field :stock_uom_uuid, :id
    field :bom_uuid, :id
    field :warehouse_uuid, :id
    field :item_uuid, :id
    field :work_order_uuid, :id

    field :work_order, :work_order, resolve: dataloader(Production, :work_order)
    field :item, :item, resolve: dataloader(Production, :item)
    field :warehouse, :warehouse, resolve: dataloader(Production, :warehouse)
    field :stock_uom, :stock_uom, resolve: dataloader(Production, :stock_uom)
  end

  object :production_queries do
    @desc "list processes"
    field :processes, list_of(:process) do
      middleware(M.Authorize, :user)
      resolve(&R.Production.list_processes/2)
    end

    @desc "get process"
    field :process, :process do
      arg(:request, non_null(:id_request))
      middleware(M.Authorize, :user)
      resolve(&R.Production.get_process/2)
    end

    @desc "get bom"
    field :bom, :bom do
      arg(:request, non_null(:id_request))

      middleware(M.Authorize, :user)

      resolve(&R.Production.get_bom/2)
    end

    @desc "list boms"
    field :boms, list_of(:bom) do
      middleware(M.Authorize, :user)
      resolve(&R.Production.list_boms/2)
    end

    @desc "get work order"
    field :work_order, :work_order do
      arg(:request, non_null(:id_request))
      middleware(M.Authorize, :user)

      resolve(&R.Production.get_work_order/2)
    end

    @desc "list work orders"
    field :work_orders, list_of(:work_order) do
      middleware(M.Authorize, :user)
      resolve(&R.Production.list_work_orders/2)
    end

    @desc "get workstation"
    field :workstation, :workstation do
      arg(:request, non_null(:id_request))
      middleware(M.Authorize, :user)
      resolve(&R.Production.get_workstation/2)
    end

    @desc "list workstations"
    field :workstations, list_of(:workstation) do
      middleware(M.Authorize, :user)
      resolve(&R.Production.list_workstations/2)
    end
  end

  object :production_mutations do
    @desc "create process"
    field :create_process, :process do
      arg(:request, non_null(:create_process_request))
      middleware(M.Authorize, :user)
      resolve(&R.Production.create_process/3)
    end

    @desc "delete process"
    field :delete_process, :process do
      arg(:request, non_null(:id_request))
      middleware(M.Authorize, :user)
      resolve(&R.Production.delete_process/3)
    end

    @desc "create bom"
    field :create_bom, :bom do
      arg(:request, non_null(:create_bom_request))
      middleware(M.Authorize, :user)
      resolve(&R.Production.create_bom/3)
    end

    @desc "delete bom"
    field :delete_bom, :bom do
      arg(:request, non_null(:bom_request))
      middleware(M.Authorize, :user)
      resolve(&R.Production.delete_bom/3)
    end

    @desc "create work order"
    field :create_work_order, :work_order do
      arg(:request, non_null(:create_work_order_request))
      middleware(M.Authorize, :user)
      resolve(&R.Production.create_work_order/3)
    end

    @desc "report job card"
    field :report_job_card, :job_card do
      arg(:request, non_null(:report_job_card_request))

      middleware(M.Authorize, :user)

      resolve(&R.Production.report_job_card/3)
    end

    @desc "create :workstation"
    field :create_workstation, :workstation do
      arg(:request, non_null(:create_workstation_request))
      middleware(M.Authorize, :user)
      resolve(&R.Production.create_workstation/3)
    end
  end

  input_object :create_work_order_request do
    field :item_uuid, :id
    field :stock_uom_uuid, :id
    field :bom_uuid, :id
    field :warehouse_uuid, :id
    field :planned_qty, :decimal
    field :start_time, :datetime
    field :end_time, :datetime
  end

  input_object :report_job_card_request do
    field :work_order_uuid, :id
    field :start_time, :datetime
    field :end_time, :datetime
    field :defective_qty, :decimal
    field :produced_qty, :decimal
  end

  input_object :create_workstation_request do
    field :name, :string
    field :description, :string
  end

  input_object :create_process_request do
    field :code, :string
    field :name, :string
    field :description, :string
  end

  input_object :create_bom_request do
    field :name, :string
    field :item_uuid, :id
    field :bom_items, list_of(:bom_item_arg)
    field :bom_processes, list_of(:bom_process_arg)
  end

  input_object :bom_request do
    field :bom_uuid, :id
  end

  input_object :work_order_request do
    field :work_order_uuid, :id
  end

  input_object :bom_item_arg do
    field :item_uuid, :id
    field :qty, :integer
  end

  input_object :bom_process_arg do
    field :process_uuid, :id
    field :position, :integer
  end
end
