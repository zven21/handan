defmodule Handan.Selling do
  @moduledoc """
  The Selling context.
  """

  alias Handan.Turbo
  alias Handan.Selling.Projections.Customer

  @doc """
  Get customer by uuid.
  """
  def get_customer(customer_uuid), do: Turbo.get(Customer, customer_uuid)
end
