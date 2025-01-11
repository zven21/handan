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
    field :item_name, :string
    field :stock_uom_uuid, :id
    field :uom_name, :string
    field :supplier_uuid, :id
    field :supplier_name, :string
    field :sales_order_uuid, :id

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
    field :item_name, :string
    field :qty, :integer
    field :uom_name, :string
    field :stock_uom_uuid, :id
    field :bom, :bom, resolve: dataloader(Production, :bom)
    field :item, :item, resolve: dataloader(Production, :item)
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
  end

  # object :production_mutations do
  # end

  # object :production_queries do
  # end
end
