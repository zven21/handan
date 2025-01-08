defmodule Handan.Production.Aggregates.Workstation do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :workstation_uuid, Ecto.UUID
    field :name, :string
    field :admin_uuid, :string
    field :members, :map, default: %{}
    field :deleted?, :boolean, default: false
  end

  alias Handan.Production.Commands.{
    CreateWorkstation,
    DeleteWorkstation
  }

  alias Handan.Production.Events.{
    WorkstationCreated,
    WorkstationDeleted
  }

  def after_event(%WorkstationDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # 创建工作站
  def execute(%__MODULE__{workstation_uuid: nil}, %CreateWorkstation{} = cmd) do
    workstation_evt = %WorkstationCreated{
      workstation_uuid: cmd.workstation_uuid,
      name: cmd.name
    }

    [workstation_evt]
  end

  def execute(_, %CreateWorkstation{}), do: {:error, :not_allowed}

  # 删除工作站
  def execute(%__MODULE__{workstation_uuid: workstation_uuid} = _state, %DeleteWorkstation{workstation_uuid: workstation_uuid} = _cmd) do
    workstation_evt = %WorkstationDeleted{
      workstation_uuid: workstation_uuid
    }

    workstation_evt
  end

  def execute(_, %DeleteWorkstation{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %WorkstationCreated{} = evt) do
    %__MODULE__{
      state
      | workstation_uuid: evt.workstation_uuid,
        name: evt.name
    }
  end

  def apply(%__MODULE__{} = state, %WorkstationDeleted{} = _evt) do
    %__MODULE__{state | deleted?: true}
  end
end
