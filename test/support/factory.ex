defmodule Handan.Factory do
  @moduledoc false

  use ExMachina

  def store_factory() do
    %{
      store_uuid: Ecto.UUID.generate(),
      name: sequence(:name, &"name-#{&1}"),
      description: sequence(:description, &"description-#{&1}")
    }
  end

  def item_factory() do
    %{
      item_uuid: Ecto.UUID.generate(),
      selling_price: 100.0,
      name: sequence(:name, &"name-#{&1}"),
      description: sequence(:description, &"description-#{&1}")
    }
  end

  def customer_factory() do
    %{
      customer_uuid: Ecto.UUID.generate(),
      name: sequence(:name, &"name-#{&1}"),
      address: sequence(:address, &"address-#{&1}")
    }
  end
end
