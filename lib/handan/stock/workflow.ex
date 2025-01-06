defmodule Handan.Stock.Workflow do
  @moduledoc false

  use Commanded.Event.Handler, application: Handan.EventApp, name: __MODULE__, consistency: :strong
end
