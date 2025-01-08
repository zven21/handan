defmodule Handan.Production.ProcessTest do
  @moduledoc false
  use Handan.DataCase

  alias Handan.Dispatcher
  alias Handan.Turbo
  alias Handan.Production.Projections.Process

  describe "create Process" do
    test "should succeed with valid request" do
      request = %{
        process_uuid: Ecto.UUID.generate(),
        name: "process-name",
        description: "process-description"
      }

      assert {:ok, %Process{} = process} = Dispatcher.run(request, :create_process)

      assert process.name == request.name
      assert process.description == request.description
    end
  end

  describe "delete Process" do
    setup [
      :create_process
    ]

    test "should succeed with valid request", %{process: process} do
      request = %{
        process_uuid: process.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_process)
      assert {:error, :not_found} == Turbo.get(Process, process.uuid)
    end
  end
end
