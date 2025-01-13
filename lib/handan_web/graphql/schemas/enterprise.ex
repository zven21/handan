defmodule HandanWeb.GraphQL.Schemas.Enterprise do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  import HandanWeb.GraphQL.Helpers.Fields, only: [timestamp_fields: 0]

  alias Handan.Enterprise

  # types
  object :company do
    field :uuid, :id
    field :name, :string
    field :description, :string

    timestamp_fields()
  end

  object :warehouse do
    field :uuid, :id
    field :name, :string
    field :address, :string
    field :area, :string
    field :contact_email, :string
    field :contact_name, :string
    field :is_default, :boolean

    timestamp_fields()
  end

  object :uom do
    field :uuid, :id
    field :name, :string
    field :description, :string

    timestamp_fields()
  end

  object :staff do
    field :uuid, :id
    field :name, :string
    field :email, :string
    field :user, :user, resolve: dataloader(Enterprise, :user)
    field :company, :company, resolve: dataloader(Enterprise, :company)

    timestamp_fields()
  end

  object :enterprise_queries do
    @desc "get current company"
    field :company, :company do
      middleware(M.Authorize, :user)

      resolve(&R.Enterprise.get_company/2)
    end

    @desc "list warehouses"
    field :warehouses, list_of(:warehouse) do
      middleware(M.Authorize, :user)

      resolve(&R.Enterprise.list_warehouses/2)
    end

    @desc "list uoms"
    field :uoms, list_of(:uom) do
      middleware(M.Authorize, :user)

      resolve(&R.Enterprise.list_uoms/2)
    end
  end

  object :enterprise_mutations do
    field :create_company, :company do
      arg(:request, non_null(:create_company_request))

      middleware(M.Authorize, :user)

      resolve(&R.Enterprise.create_company/3)
    end
  end

  input_object :create_company_request do
    field :name, :string
    field :description, :string
  end
end
