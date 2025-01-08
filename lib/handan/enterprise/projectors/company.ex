defmodule Handan.Enterprise.Projectors.Store do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Enterprise.Events.{
    CompanyCreated,
    CompanyDeleted,
    StaffAdded
  }

  alias Handan.Enterprise.Projections.{
    Company,
    Staff
  }

  project(
    %CompanyCreated{} = evt,
    _meta,
    fn multi ->
      company = %Company{
        uuid: evt.company_uuid,
        name: evt.name,
        description: evt.description
      }

      Ecto.Multi.insert(multi, :company_created, company)
    end
  )

  project(%CompanyDeleted{company_uuid: uuid}, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :company_deleted, company_query(uuid))
  end)

  project(%StaffAdded{} = evt, _meta, fn multi ->
    staff = %Staff{
      uuid: evt.staff_uuid,
      name: evt.name,
      mobile: evt.mobile,
      user_uuid: evt.user_uuid,
      company_uuid: evt.company_uuid
    }

    Ecto.Multi.insert(multi, :staff_added, staff)
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  def company_query(uuid) do
    from(c in Company, where: c.uuid == ^uuid)
  end
end
