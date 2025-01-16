defmodule HandanWeb.GraphQL.Schemas.Accounts do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite
  import HandanWeb.GraphQL.Helpers.Fields, only: [timestamp_fields: 0]

  object :user do
    field :uuid, :id
    field :email, :string
    field :nickname, :string
    field :avatar_url, :string
    field :bio, :string
    field :access_token, :string

    timestamp_fields()
  end

  object :accounts_queries do
    field :current_user, :user do
      middleware(M.Authorize, :user)
      resolve(&R.Accounts.get_current_user/2)
    end
  end

  object :accounts_mutations do
    @desc "login"
    field :login, :user do
      arg(:request, non_null(:login_request))

      resolve(&R.Accounts.login/3)
    end

    @desc "register"
    field :register, :user do
      arg(:request, non_null(:register_request))

      resolve(&R.Accounts.register/3)
    end
  end

  input_object :login_request do
    field :email, :string
    field :password, :string
  end

  input_object :register_request do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :nickname, :string
    field :avatar_url, :string
  end
end
