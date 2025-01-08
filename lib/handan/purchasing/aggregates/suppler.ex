defmodule Handan.Purchasing.Aggregates.Supplier do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :supplier_uuid, Ecto.UUID
    field :name, :string
    field :address, :string
    field :deleted?, :boolean, default: false
  end

  alias Handan.Purchasing.Commands.{
    CreateSupplier,
    DeleteSupplier
  }

  alias Handan.Purchasing.Events.{
    SupplierCreated,
    SupplierDeleted
  }

  def after_event(%SupplierDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # 创建供应商
  def execute(%__MODULE__{supplier_uuid: nil}, %CreateSupplier{} = cmd) do
    supplier_evt = %SupplierCreated{
      supplier_uuid: cmd.supplier_uuid,
      name: cmd.name,
      address: cmd.address
    }

    supplier_evt
  end

  def execute(_, %CreateSupplier{}), do: {:error, :not_allowed}

  # 删除供应商
  def execute(%__MODULE__{supplier_uuid: supplier_uuid} = _state, %DeleteSupplier{supplier_uuid: supplier_uuid} = _cmd) do
    supplier_evt = %SupplierDeleted{
      supplier_uuid: supplier_uuid
    }

    supplier_evt
  end

  def execute(_, %DeleteSupplier{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %SupplierCreated{} = evt) do
    %__MODULE__{
      state
      | supplier_uuid: evt.supplier_uuid,
        name: evt.name,
        address: evt.address
    }
  end

  def apply(%__MODULE__{} = state, %SupplierDeleted{} = _evt) do
    %__MODULE__{state | deleted?: true}
  end
end
