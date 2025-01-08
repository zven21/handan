defmodule Handan.Enterprise do
  @moduledoc """
  The Enterprise context.
  """

  alias Handan.Turbo
  alias Handan.Enterprise.Projections.Staff

  @doc """
  Get staff by uuid.
  """
  def get_staff(uuid), do: Turbo.get(Staff, uuid)
end
