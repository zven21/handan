defmodule Handan.Production.Loader do
  @moduledoc """
  dataloader for production
  """

  alias Handan.Repo

  def data, do: Dataloader.Ecto.new(Repo, query: &query/2)

  def query(queryable, _args), do: queryable
end
