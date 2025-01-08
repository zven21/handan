defmodule Handan.Finance.Aggregates.PaymentMethod do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :payment_method_uuid, Ecto.UUID
    field :name, :string
    field :deleted?, :boolean, default: false
  end

  alias Handan.Finance.Commands.{
    CreatePaymentMethod,
    DeletePaymentMethod
  }

  alias Handan.Finance.Events.{
    PaymentMethodCreated,
    PaymentMethodDeleted
  }

  def after_event(%PaymentMethodDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # 创建支付方式
  def execute(%__MODULE__{payment_method_uuid: nil}, %CreatePaymentMethod{} = cmd) do
    payment_method_evt = %PaymentMethodCreated{
      payment_method_uuid: cmd.payment_method_uuid,
      name: cmd.name
    }

    payment_method_evt
  end

  def execute(_, %CreatePaymentMethod{}), do: {:error, :not_allowed}

  # 删除支付方式
  def execute(%__MODULE__{} = _state, %DeletePaymentMethod{} = cmd) do
    payment_method_evt = %PaymentMethodDeleted{
      payment_method_uuid: cmd.payment_method_uuid
    }

    payment_method_evt
  end

  def execute(_, %DeletePaymentMethod{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %PaymentMethodCreated{} = evt) do
    %__MODULE__{
      state
      | payment_method_uuid: evt.payment_method_uuid,
        name: evt.name
    }
  end

  def apply(%__MODULE__{} = state, %PaymentMethodDeleted{} = _evt) do
    %__MODULE__{state | deleted?: true}
  end
end
