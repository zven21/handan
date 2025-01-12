defmodule HandanWeb.GraphQL.Resolvers.Finance do
  @moduledoc false

  alias Handan.Finance
  alias Handan.Dispatcher

  @doc "get payment entry"
  def get_payment_entry(%{request: %{uuid: uuid}}, _), do: Finance.get_payment_entry(uuid)

  @doc "list payment entries"
  def list_payment_entries(_, _), do: Finance.list_payment_entries()

  @doc "get payment method"
  def get_payment_method(%{request: %{uuid: uuid}}, _), do: Finance.get_payment_method(uuid)

  @doc "list payment methods"
  def list_payment_methods(_, _), do: Finance.list_payment_methods()

  @doc "create payment entry"
  def create_payment_entry(_, %{request: request}, _) do
    request
    |> Map.put(:payment_entry_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_payment_entry)
  end

  @doc "create payment method"
  def create_payment_method(_, %{request: request}, _) do
    request
    |> Map.put(:payment_method_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_payment_method)
  end
end
