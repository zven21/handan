defmodule Handan.Selling.Seed do
  @moduledoc false

  alias Handan.Dispatcher

  def create_customer do
    request = %{
      customer_uuid: Ecto.UUID.generate(),
      name: "Customer 1",
      address: "Address 1"
    }

    Dispatcher.run(request, :create_customer)
  end
end
