defmodule Handan.Finance do
  @moduledoc """
  The Finance context.
  """

  alias Handan.Turbo
  alias Handan.Finance.Projections.PaymentMethod

  @doc """
  Get payment method by uuid.
  """
  def get_payment_method(payment_method_uuid), do: Turbo.get(PaymentMethod, payment_method_uuid)
end
