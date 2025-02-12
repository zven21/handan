defmodule Handan.EventRouter do
  @moduledoc false

  use Commanded.Commands.CompositeRouter

  router(Handan.Enterprise.Router)
  router(Handan.Stock.Router)
  router(Handan.Selling.Router)
  router(Handan.Accounts.Router)
  router(Handan.Purchasing.Router)
  router(Handan.Production.Router)
  router(Handan.Finance.Router)
end
