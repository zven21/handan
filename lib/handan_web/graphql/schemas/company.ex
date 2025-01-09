defmodule HandanWeb.GraphQL.Schemas.Company do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite
  import HandanWeb.GraphQL.Helpers.Fields

  # types
  object :company do
    field :uuid, :id
    field :name, :string
    field :description, :string

    timestamp_fields()
  end

  object :company_queries do
    @desc "get current company"
    field :current_company, :company do
      middleware(M.Authorize, :user)

      resolve(&R.Enterprise.get_company/2)
    end
  end
end
