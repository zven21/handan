defmodule HandanWeb.GraphQL.Helpers.ErrorCode do
  @moduledoc """
  error code map for all site
  """

  @default_base 4000
  @changeset_base 4100
  @throttle_base 4200
  @account_base 4300
  @featured 5000

  @spec raise_error(:atom, String.t()) :: {:error, [message: String.t(), code: :integer]}
  def raise_error(code_atom, msg) do
    {:error, [message: msg, code: ecode(code_atom)]}
  end

  # account error code
  def ecode(:unauthenticated), do: @default_base
  def ecode(:account_login), do: @account_base + 1
  def ecode(:passport), do: @account_base + 2

  # changeset error code
  def ecode(:changeset), do: @changeset_base + 2

  # default errors
  def ecode(:custom), do: @default_base + 1
  def ecode(:pagination), do: @default_base + 2
  def ecode(:not_exsit), do: @default_base + 3
  def ecode(:already_did), do: @default_base + 4
  def ecode(:self_conflict), do: @default_base + 5
  def ecode(:react_fails), do: @default_base + 6
  def ecode(:already_exsit), do: @default_base + 7
  def ecode(:update_fails), do: @default_base + 8
  def ecode(:delete_fails), do: @default_base + 9
  def ecode(:create_fails), do: @default_base + 10

  # throttle
  def ecode(:throttle_inverval), do: @throttle_base + 1
  def ecode(:throttle_hour), do: @throttle_base + 2
  def ecode(:throttle_day), do: @throttle_base + 3

  def ecode, do: @featured
end
