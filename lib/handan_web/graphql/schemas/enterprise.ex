defmodule HandanWeb.GraphQL.Schemas.Enterprise do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  import HandanWeb.GraphQL.Helpers.Fields

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
  end

  object :uom do
    field :uuid, :id
    field :name, :string
    field :description, :string
  end

  object :staff do
    field :uuid, :id
    field :name, :string
    field :email, :string
    field :user, :user, resolve: dataloader(HandanWeb.GraphQL.Schemas.Accounts, :user)
    field :company, :company, resolve: dataloader(HandanWeb.GraphQL.Schemas.Enterprise, :company)
  end

  object :enterprise_queries do
    @desc "get current company"
    field :current_company, :company do
      middleware(M.Authorize, :user)

      resolve(&R.Enterprise.get_company/2)
    end
  end

  object :enterprise_mutations do
    field :create_company, :company do
      resolve(fn _, _, _ -> {:ok, %{}} end)
    end
  end
end
