defmodule Handan.Production.BOMTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Dispatcher
  alias Handan.Turbo
  alias Handan.Production.Projections.BOM

  describe "create BOM" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_process
    ]

    test "should succeed with valid request", %{item: item} do
      request = %{
        bom_uuid: Ecto.UUID.generate(),
        name: "bom-name",
        item_uuid: item.uuid
      }

      assert {:ok, %BOM{} = bom} = Dispatcher.run(request, :create_bom)

      assert bom.name == request.name
    end

    test "should succeed with valid request with bom_items", %{item: item} do
      request = %{
        bom_uuid: Ecto.UUID.generate(),
        name: "bom-name",
        item_uuid: item.uuid,
        bom_items: [
          %{
            item_uuid: item.uuid,
            qty: 1
          }
        ]
      }

      assert {:ok, %BOM{} = bom} = Dispatcher.run(request, :create_bom)
      assert length(bom.bom_items) == 1
    end

    test "should succeed with valid request with bom_processes", %{item: item, process: process} do
      request = %{
        bom_uuid: Ecto.UUID.generate(),
        name: "bom-name",
        item_uuid: item.uuid,
        bom_processes: [
          %{
            process_uuid: process.uuid,
            position: 1
          }
        ]
      }

      assert {:ok, %BOM{} = bom} = Dispatcher.run(request, :create_bom)
      assert length(bom.bom_processes) == 1
    end
  end

  describe "delete BOM" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom
    ]

    test "should succeed with valid request", %{bom: bom} do
      request = %{
        bom_uuid: bom.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_bom)
      assert {:error, :not_found} == Turbo.get(BOM, bom.uuid)
    end
  end
end
