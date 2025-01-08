defmodule Handan.Finance.PaymentMethodTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Finance.Projections.PaymentMethod

  describe "create payment method" do
    test "should succeed with valid request" do
      request = %{
        payment_method_uuid: Ecto.UUID.generate(),
        name: "payment-method-name"
      }

      assert {:ok, %PaymentMethod{} = payment_method} = Dispatcher.run(request, :create_payment_method)

      assert payment_method.name == request.name
    end
  end

  describe "delete payment method" do
    setup [
      :create_payment_method
    ]

    test "should succeed with valid request", %{payment_method: payment_method} do
      request = %{
        payment_method_uuid: payment_method.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_payment_method)
      assert {:error, :not_found} == Turbo.get(PaymentMethod, payment_method.uuid)
    end
  end
end
