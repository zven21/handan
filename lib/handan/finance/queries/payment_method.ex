defmodule Handan.Finance.Queries.PaymentMethodQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Finance.Projections.PaymentMethod

  def get_payment_method(payment_method_uuid), do: Turbo.get(PaymentMethod, payment_method_uuid)
end
