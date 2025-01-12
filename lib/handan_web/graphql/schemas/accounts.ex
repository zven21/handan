defmodule HandanWeb.GraphQL.Schemas.Accounts do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  object :user do
    field :uuid, :id
    field :email, :string
    field :nickname, :string
    field :avatar_url, :string
    field :bio, :string
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
      resolve(fn _, _, _ -> {:ok, %{}} end)
    end
  end

  input_object :login_request do
    field :email, :string
    field :password, :string
  end
end
