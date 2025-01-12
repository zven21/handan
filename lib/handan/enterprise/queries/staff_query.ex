defmodule Handan.Enterprise.Queries.StaffQuery do
  @moduledoc false

  import Ecto.Query

  alias Handan.Repo
  alias Handan.Turbo
  alias Handan.Enterprise.Projections.Staff

  def get_staff(staff_uuid), do: Turbo.get(Staff, staff_uuid)

  def get_staff(user_uuid, company_uuid) do
    from(s in Staff, where: s.user_uuid == ^user_uuid and s.company_uuid == ^company_uuid)
    |> Repo.one()
  end
end
