defmodule Handan.EventRouter do
  @moduledoc false

  use Commanded.Commands.CompositeRouter

  router(Handan.Stock.Router)
end
