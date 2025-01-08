defmodule Handan.Production.Aggregates.Process do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :process_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
    field :deleted?, :boolean, default: false
  end

  alias Handan.Production.Commands.{
    CreateProcess,
    DeleteProcess
  }

  alias Handan.Production.Events.{
    ProcessCreated,
    ProcessDeleted
  }

  def after_event(%ProcessDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # 创建Process
  def execute(%__MODULE__{process_uuid: nil}, %CreateProcess{} = cmd) do
    process_evt = %ProcessCreated{
      process_uuid: cmd.process_uuid,
      name: cmd.name,
      description: cmd.description
    }

    process_evt
  end

  def execute(_, %CreateProcess{}), do: {:error, :not_allowed}

  # 删除Process
  def execute(%__MODULE__{process_uuid: process_uuid} = _state, %DeleteProcess{process_uuid: process_uuid} = _cmd) do
    process_evt = %ProcessDeleted{
      process_uuid: process_uuid
    }

    process_evt
  end

  def execute(_, %DeleteProcess{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %ProcessCreated{} = evt) do
    %__MODULE__{
      state
      | process_uuid: evt.process_uuid,
        name: evt.name,
        description: evt.description
    }
  end

  def apply(%__MODULE__{} = state, %ProcessDeleted{} = _evt) do
    %__MODULE__{state | deleted?: true}
  end
end
