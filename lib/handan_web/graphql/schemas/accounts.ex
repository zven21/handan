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

      resolve(fn _, _, _ -> {:ok, %{}} end)
    end
  end

  object :accounts_mutations do
    @desc "login"
    field :login, :user do
      resolve(fn _, _, _ -> {:ok, %{}} end)
    end

    @desc "register"
    field :register, :user do
      resolve(fn _, _, _ -> {:ok, %{}} end)
    end
  end
end
