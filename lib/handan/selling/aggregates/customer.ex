defmodule Handan.Selling.Aggregates.Customer do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :customer_uuid, Ecto.UUID
    field :name, :string
    field :address, :string
    field :deleted?, :boolean, default: false
  end

  alias Handan.Selling.Commands.{
    CreateCustomer,
    DeleteCustomer
  }

  alias Handan.Selling.Events.{
    CustomerCreated,
    CustomerDeleted
  }

  def after_event(%CustomerDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # 创建客户
  def execute(%__MODULE__{customer_uuid: nil}, %CreateCustomer{} = cmd) do
    customer_evt = %CustomerCreated{
      customer_uuid: cmd.customer_uuid,
      name: cmd.name,
      address: cmd.address
    }

    customer_evt
  end

  def execute(_, %CreateCustomer{}), do: {:error, :not_allowed}

  # 删除客户
  def execute(%__MODULE__{} = _state, %DeleteCustomer{} = cmd) do
    customer_evt = %CustomerDeleted{
      customer_uuid: cmd.customer_uuid
    }

    customer_evt
  end

  def execute(_, %DeleteCustomer{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %CustomerCreated{} = evt) do
    %__MODULE__{
      state
      | customer_uuid: evt.customer_uuid,
        name: evt.name,
        address: evt.address
    }
  end

  def apply(%__MODULE__{} = state, %CustomerDeleted{} = _evt) do
    %__MODULE__{state | deleted?: true}
  end
end
