defmodule HandanWeb.Schema do
  @moduledoc """
  GraphQL schema for Handan.
  """

  use Absinthe.Schema
  # alias HandanWeb.GraphQL.Middlewares, as: M

  # types
  import_types(Absinthe.Type.Custom)

  import_types(HandanWeb.GraphQL.Schemas.Accounts)
  import_types(HandanWeb.GraphQL.Schemas.Enterprise)
  import_types(HandanWeb.GraphQL.Schemas.Selling)
  import_types(HandanWeb.GraphQL.Schemas.Purchasing)
  import_types(HandanWeb.GraphQL.Schemas.Stock)
  import_types(HandanWeb.GraphQL.Schemas.Production)
  import_types(HandanWeb.GraphQL.Schemas.Finance)

  @desc "the root of query."
  query do
    import_fields(:accounts_queries)
    import_fields(:enterprise_queries)
    import_fields(:selling_queries)
    import_fields(:purchasing_queries)
    import_fields(:production_queries)
    import_fields(:stock_queries)
  end

  @desc "the root of mutaion."
  mutation do
    import_fields(:accounts_mutations)
    import_fields(:enterprise_mutations)
    import_fields(:selling_mutations)
    import_fields(:purchasing_mutations)
    import_fields(:production_mutations)
    import_fields(:stock_mutations)
    import_fields(:finance_mutations)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def dataloader do
    alias Handan.{Accounts, Enterprise, Production, Stock, Selling, Purchasing, Finance}

    Dataloader.new()
    |> Dataloader.add_source(Accounts, Accounts.Loader.data())
    |> Dataloader.add_source(Enterprise, Enterprise.Loader.data())
    |> Dataloader.add_source(Production, Production.Loader.data())
    |> Dataloader.add_source(Stock, Stock.Loader.data())
    |> Dataloader.add_source(Selling, Selling.Loader.data())
    |> Dataloader.add_source(Purchasing, Purchasing.Loader.data())
    |> Dataloader.add_source(Finance, Finance.Loader.data())
  end

  def context(ctx) do
    ctx |> Map.put(:loader, dataloader())
  end
end
