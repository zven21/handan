defmodule Handan.Production do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Production.Projections.Process

  @doc """
  Get process by uuid
  """
  def get_process(process_uuid), do: Turbo.get(Process, process_uuid)

  alias Handan.Production.ProductionPlan

  @doc """
  Returns the list of production_plans.

  ## Examples

      iex> list_production_plans()
      [%ProductionPlan{}, ...]

  """
  def list_production_plans do
    Repo.all(ProductionPlan)
  end

  @doc """
  Gets a single production_plan.

  Raises `Ecto.NoResultsError` if the Production plan does not exist.

  ## Examples

      iex> get_production_plan!(123)
      %ProductionPlan{}

      iex> get_production_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_production_plan!(id), do: Repo.get!(ProductionPlan, id)

  @doc """
  Creates a production_plan.

  ## Examples

      iex> create_production_plan(%{field: value})
      {:ok, %ProductionPlan{}}

      iex> create_production_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_production_plan(attrs \\ %{}) do
    %ProductionPlan{}
    |> ProductionPlan.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a production_plan.

  ## Examples

      iex> update_production_plan(production_plan, %{field: new_value})
      {:ok, %ProductionPlan{}}

      iex> update_production_plan(production_plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_production_plan(%ProductionPlan{} = production_plan, attrs) do
    production_plan
    |> ProductionPlan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a production_plan.

  ## Examples

      iex> delete_production_plan(production_plan)
      {:ok, %ProductionPlan{}}

      iex> delete_production_plan(production_plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_production_plan(%ProductionPlan{} = production_plan) do
    Repo.delete(production_plan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking production_plan changes.

  ## Examples

      iex> change_production_plan(production_plan)
      %Ecto.Changeset{data: %ProductionPlan{}}

  """
  def change_production_plan(%ProductionPlan{} = production_plan, attrs \\ %{}) do
    ProductionPlan.changeset(production_plan, attrs)
  end

  alias Handan.Production.ProductionPlanItem

  @doc """
  Returns the list of production_plan_items.

  ## Examples

      iex> list_production_plan_items()
      [%ProductionPlanItem{}, ...]

  """
  def list_production_plan_items do
    Repo.all(ProductionPlanItem)
  end

  @doc """
  Gets a single production_plan_item.

  Raises `Ecto.NoResultsError` if the Production plan item does not exist.

  ## Examples

      iex> get_production_plan_item!(123)
      %ProductionPlanItem{}

      iex> get_production_plan_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_production_plan_item!(id), do: Repo.get!(ProductionPlanItem, id)

  @doc """
  Creates a production_plan_item.

  ## Examples

      iex> create_production_plan_item(%{field: value})
      {:ok, %ProductionPlanItem{}}

      iex> create_production_plan_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_production_plan_item(attrs \\ %{}) do
    %ProductionPlanItem{}
    |> ProductionPlanItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a production_plan_item.

  ## Examples

      iex> update_production_plan_item(production_plan_item, %{field: new_value})
      {:ok, %ProductionPlanItem{}}

      iex> update_production_plan_item(production_plan_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_production_plan_item(%ProductionPlanItem{} = production_plan_item, attrs) do
    production_plan_item
    |> ProductionPlanItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a production_plan_item.

  ## Examples

      iex> delete_production_plan_item(production_plan_item)
      {:ok, %ProductionPlanItem{}}

      iex> delete_production_plan_item(production_plan_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_production_plan_item(%ProductionPlanItem{} = production_plan_item) do
    Repo.delete(production_plan_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking production_plan_item changes.

  ## Examples

      iex> change_production_plan_item(production_plan_item)
      %Ecto.Changeset{data: %ProductionPlanItem{}}

  """
  def change_production_plan_item(%ProductionPlanItem{} = production_plan_item, attrs \\ %{}) do
    ProductionPlanItem.changeset(production_plan_item, attrs)
  end

  alias Handan.Production.WorkOrder

  @doc """
  Returns the list of work_orders.

  ## Examples

      iex> list_work_orders()
      [%WorkOrder{}, ...]

  """
  def list_work_orders do
    Repo.all(WorkOrder)
  end

  @doc """
  Gets a single work_order.

  Raises `Ecto.NoResultsError` if the Work order does not exist.

  ## Examples

      iex> get_work_order!(123)
      %WorkOrder{}

      iex> get_work_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_order!(id), do: Repo.get!(WorkOrder, id)

  @doc """
  Creates a work_order.

  ## Examples

      iex> create_work_order(%{field: value})
      {:ok, %WorkOrder{}}

      iex> create_work_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_order(attrs \\ %{}) do
    %WorkOrder{}
    |> WorkOrder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_order.

  ## Examples

      iex> update_work_order(work_order, %{field: new_value})
      {:ok, %WorkOrder{}}

      iex> update_work_order(work_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_order(%WorkOrder{} = work_order, attrs) do
    work_order
    |> WorkOrder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_order.

  ## Examples

      iex> delete_work_order(work_order)
      {:ok, %WorkOrder{}}

      iex> delete_work_order(work_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_order(%WorkOrder{} = work_order) do
    Repo.delete(work_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_order changes.

  ## Examples

      iex> change_work_order(work_order)
      %Ecto.Changeset{data: %WorkOrder{}}

  """
  def change_work_order(%WorkOrder{} = work_order, attrs \\ %{}) do
    WorkOrder.changeset(work_order, attrs)
  end

  alias Handan.Production.WorkOrderItem

  @doc """
  Returns the list of work_order_uuid.

  ## Examples

      iex> list_work_order_uuid()
      [%WorkOrderItem{}, ...]

  """
  def list_work_order_uuid do
    Repo.all(WorkOrderItem)
  end

  @doc """
  Gets a single work_order_item.

  Raises `Ecto.NoResultsError` if the Work order item does not exist.

  ## Examples

      iex> get_work_order_item!(123)
      %WorkOrderItem{}

      iex> get_work_order_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_order_item!(id), do: Repo.get!(WorkOrderItem, id)

  @doc """
  Creates a work_order_item.

  ## Examples

      iex> create_work_order_item(%{field: value})
      {:ok, %WorkOrderItem{}}

      iex> create_work_order_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_order_item(attrs \\ %{}) do
    %WorkOrderItem{}
    |> WorkOrderItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_order_item.

  ## Examples

      iex> update_work_order_item(work_order_item, %{field: new_value})
      {:ok, %WorkOrderItem{}}

      iex> update_work_order_item(work_order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_order_item(%WorkOrderItem{} = work_order_item, attrs) do
    work_order_item
    |> WorkOrderItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_order_item.

  ## Examples

      iex> delete_work_order_item(work_order_item)
      {:ok, %WorkOrderItem{}}

      iex> delete_work_order_item(work_order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_order_item(%WorkOrderItem{} = work_order_item) do
    Repo.delete(work_order_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_order_item changes.

  ## Examples

      iex> change_work_order_item(work_order_item)
      %Ecto.Changeset{data: %WorkOrderItem{}}

  """
  def change_work_order_item(%WorkOrderItem{} = work_order_item, attrs \\ %{}) do
    WorkOrderItem.changeset(work_order_item, attrs)
  end

  alias Handan.Production.JobCard

  @doc """
  Returns the list of job_cards.

  ## Examples

      iex> list_job_cards()
      [%JobCard{}, ...]

  """
  def list_job_cards do
    Repo.all(JobCard)
  end

  @doc """
  Gets a single job_card.

  Raises `Ecto.NoResultsError` if the Job card does not exist.

  ## Examples

      iex> get_job_card!(123)
      %JobCard{}

      iex> get_job_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job_card!(id), do: Repo.get!(JobCard, id)

  @doc """
  Creates a job_card.

  ## Examples

      iex> create_job_card(%{field: value})
      {:ok, %JobCard{}}

      iex> create_job_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job_card(attrs \\ %{}) do
    %JobCard{}
    |> JobCard.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job_card.

  ## Examples

      iex> update_job_card(job_card, %{field: new_value})
      {:ok, %JobCard{}}

      iex> update_job_card(job_card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job_card(%JobCard{} = job_card, attrs) do
    job_card
    |> JobCard.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job_card.

  ## Examples

      iex> delete_job_card(job_card)
      {:ok, %JobCard{}}

      iex> delete_job_card(job_card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job_card(%JobCard{} = job_card) do
    Repo.delete(job_card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job_card changes.

  ## Examples

      iex> change_job_card(job_card)
      %Ecto.Changeset{data: %JobCard{}}

  """
  def change_job_card(%JobCard{} = job_card, attrs \\ %{}) do
    JobCard.changeset(job_card, attrs)
  end
end
