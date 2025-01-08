defmodule Handan.Production.WorkstationTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Dispatcher
  alias Handan.Turbo
  alias Handan.Production.Projections.Workstation

  describe "create workstation" do
    test "should succeed with valid request" do
      request = %{
        workstation_uuid: Ecto.UUID.generate(),
        name: "workstation-name"
      }

      assert {:ok, %Workstation{} = workstation} = Dispatcher.run(request, :create_workstation)

      assert workstation.name == request.name
    end
  end

  describe "delete workstation" do
    setup [:create_workstation]

    test "should succeed with valid request", %{workstation: workstation} do
      request = %{
        workstation_uuid: workstation.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_workstation)
      assert {:error, :not_found} == Turbo.get(Workstation, workstation.uuid)
    end
  end
end
