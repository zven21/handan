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
      :create_item
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
