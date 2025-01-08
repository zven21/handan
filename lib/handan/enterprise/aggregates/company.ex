defmodule Handan.Enterprise.Aggregates.Company do
  @moduledoc """
  Aggregate for company.
  Represents the meaning of small and medium-sized enterprises, this is the basic information configuration of the enterprise.
  """

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :company_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
    field :deleted?, :boolean, default: false
    field :uoms, :map, default: %{}
    field :warehouses, :map, default: %{}
  end

  alias Handan.Enterprise.Commands.{
    CreateCompany,
    DeleteCompany
  }

  alias Handan.Enterprise.Events.{
    CompanyCreated,
    CompanyDeleted
  }

  alias Handan.Enterprise.Events.UOMCreated
  alias Handan.Enterprise.Events.WarehouseCreated

  @default_units ["个", "包", "箱", "件", "瓶", "袋", "盒", "条", "支", "瓶", "盒", "条", "支"]
  @default_warehouse_name "默认仓库"

  @doc """
  Stop the company aggregate after it has been deleted
  """
  def after_event(%CompanyDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # create store
  def execute(%__MODULE__{company_uuid: nil}, %CreateCompany{} = cmd) do
    company_evt = %CompanyCreated{
      company_uuid: cmd.company_uuid,
      name: cmd.name,
      description: cmd.description
    }

    uom_evts =
      @default_units
      |> Enum.map(fn unit ->
        %UOMCreated{
          uom_uuid: Ecto.UUID.generate(),
          name: unit,
          description: unit
        }
      end)

    warehouse_evt = %WarehouseCreated{
      warehouse_uuid: Ecto.UUID.generate(),
      name: @default_warehouse_name,
      is_default: true,
      address: "",
      contact_name: "",
      contact_mobile: ""
    }

    [company_evt, uom_evts, warehouse_evt] |> List.flatten()
  end

  def execute(_, %CreateCompany{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{company_uuid: company_uuid} = _state, %DeleteCompany{company_uuid: company_uuid} = _cmd) do
    %CompanyDeleted{
      company_uuid: company_uuid
    }
  end

  def execute(_, %DeleteCompany{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %CompanyCreated{} = evt) do
    %__MODULE__{
      state
      | company_uuid: evt.company_uuid,
        name: evt.name,
        description: evt.description
    }
  end

  def apply(%__MODULE__{} = state, %CompanyDeleted{} = _evt) do
    %__MODULE__{
      state
      | deleted?: true
    }
  end

  def apply(%__MODULE__{} = state, %UOMCreated{} = evt) do
    uoms = Map.put(state.uoms, evt.uom_uuid, Map.from_struct(evt))

    %{state | uoms: uoms}
  end

  def apply(%__MODULE__{} = state, %WarehouseCreated{} = evt) do
    warehouses = Map.put(state.warehouses, evt.warehouse_uuid, Map.from_struct(evt))

    %{state | warehouses: warehouses}
  end
end
