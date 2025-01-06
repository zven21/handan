defmodule Handan.EventRouter do
  @moduledoc false

  use Commanded.Commands.CompositeRouter

  router(Handan.Enterprise.Router)
  router(Handan.Stock.Router)
  router(Handan.Selling.Router)
end
