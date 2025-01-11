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

  # object :account_queries do
  # end

  # object :account_mutations do
  # end
end
