defmodule HandanWeb.GraphQL.Helpers.GQLSchemaSuite do
  @moduledoc """
  helper for reduce boilerplate import/use/alias in absinthe schema
  """

  defmacro __using__(_opts) do
    quote do
      use Absinthe.Schema.Notation

      alias HandanWeb.GraphQL.Resolvers, as: R
      alias HandanWeb.GraphQL.Middlewares, as: M
    end
  end
end
