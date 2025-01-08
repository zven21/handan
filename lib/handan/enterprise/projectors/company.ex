defmodule Handan.Enterprise.Projectors.Store do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Enterprise.Events.{
    CompanyCreated,
    CompanyDeleted
  }

  alias Handan.Enterprise.Projections.Company

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

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  def company_query(uuid) do
    from(c in Company, where: c.uuid == ^uuid)
  end
end
