defmodule Handan.Production.Queries.BOMQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Production.Projections.BOM

  def get_bom(bom_uuid), do: Turbo.get(BOM, bom_uuid)
end
