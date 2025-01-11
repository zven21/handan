defmodule Handan.Enterprise do
  @moduledoc """
  The Enterprise context.
  """

  import Ecto.Query
  alias Handan.Repo
  alias Handan.Turbo
  alias Handan.Enterprise.Projections.{Staff, Company}

  @doc """
  Get staff by uuid.
  """
  def get_staff(uuid), do: Turbo.get(Staff, uuid)

  @doc """
  Get company by uuid.
  """
  def get_company(uuid), do: Turbo.get(Company, uuid)

  @doc """
  Get staff by user uuid and company uuid.
  """
  def get_staff(user_uuid, company_uuid) do
    from(s in Staff, where: s.user_uuid == ^user_uuid and s.company_uuid == ^company_uuid)
    |> Repo.one()
  end
end
