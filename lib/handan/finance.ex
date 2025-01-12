defmodule Handan.Finance do
  @moduledoc """
  The Finance context.
  """

  alias Handan.Turbo
  alias Handan.Finance.Projections.{PaymentMethod, PaymentEntry}

  @doc """
  Get payment method by uuid.
  """
  def get_payment_method(payment_method_uuid), do: Turbo.get(PaymentMethod, payment_method_uuid)

  @doc """
  List payment methods.
  """
  def list_payment_methods, do: Turbo.list(PaymentMethod)

  @doc """
  Create payment method.
  """
  def get_payment_entry(payment_entry_uuid), do: Turbo.get(PaymentEntry, payment_entry_uuid)

  @doc """
  List payment entries.
  """
  def list_payment_entries, do: Turbo.list(PaymentEntry)
end
