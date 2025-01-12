defmodule HandanWeb.GraphQL.Resolvers.Production do
  @moduledoc false

  alias Handan.Production
  alias Handan.Dispatcher

  @doc "get process"
  def get_process(%{request: %{uuid: uuid}}, _), do: Production.get_process(uuid)

  @doc "list processes"
  def list_processes(_, _), do: Production.list_processes()

  @doc "get work order"
  def get_work_order(%{request: %{uuid: uuid}}, _), do: Production.get_work_order(uuid)

  @doc "list work orders"
  def get_work_orders(_, _), do: Production.list_work_orders()

  @doc "create process"
  def create_process(_, %{request: request}, _) do
    request
    |> Map.put(:process_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_process)
  end

  @doc "create work order"
  def create_work_order(_, %{request: request}, _) do
    request
    |> Map.put(:work_order_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_work_order)
  end

  @doc "update work order"
  def update_work_order(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:update_work_order)
  end

  @doc "delete work order"
  def delete_work_order(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:delete_work_order)
  end

  @doc "report job card"
  def report_job_card(_, %{request: request}, _) do
    request
    |> Dispatcher.run(:report_job_card)
  end

  @doc "create workstation"
  def create_workstation(_, %{request: request}, _) do
    request
    |> Map.put(:workstation_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_workstation)
  end
end
