defmodule Handan.Finance.Projections.PaymentMethod do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "payment_methods" do
    field :name, :string
    timestamps(type: :utc_datetime)
  end
end
