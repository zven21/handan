defmodule Handan.Selling.Queries.CustomerQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Selling.Projections.Customer

  @doc "get customer"
  def get_customer(uuid), do: Turbo.get(Customer, uuid)

  @doc "list customers"
  def list_customers, do: Turbo.list(Customer)
end
