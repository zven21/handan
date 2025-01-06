defmodule Handan.Enterprise.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      Handan.Enterprise.Projectors.Store,
      Handan.Enterprise.Projectors.UOM,
      Handan.Enterprise.Projectors.Warehouse
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
