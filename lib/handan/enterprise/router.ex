defmodule Handan.Enterprise.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Enterprise.Aggregates.{
    Company
  }

  alias Handan.Enterprise.Commands.{
    CreateCompany,
    DeleteCompany
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(Company, by: :company_uuid, prefix: "company-")

  dispatch(
    [
      CreateCompany,
      DeleteCompany
    ],
    to: Company,
    lifespan: Company
  )
end
