defmodule Handan.Turbo do
  @moduledoc """
  Ecto Enhance API
  """

  import Ecto.Query, warn: false

  alias Handan.Repo

  @doc "list all"
  def list(queryable) do
    queryable
    |> Repo.all()
    |> done(queryable)
  end

  @doc """
  Finds a object by it's uuid.
  """
  def get(queryable, uuid, preload: preload) do
    queryable
    |> preload(^preload)
    |> Repo.get(uuid)
    |> done(queryable, uuid)
  end

  def get(queryable, uuid) do
    queryable
    |> Repo.get(uuid)
    |> done(queryable, uuid)
  end

  @doc """
  simular to Repo.get_by/3, with standard result/error handle
  """
  def get_by(queryable, clauses, preload: preload) do
    queryable
    |> preload(^preload)
    |> Repo.get_by(clauses)
    |> case do
      nil ->
        {:error, :not_found}

      result ->
        {:ok, result}
    end
  end

  def get_by(queryable, clauses) do
    queryable
    |> Repo.get_by(clauses)
    |> case do
      nil ->
        {:error, :not_found}

      result ->
        {:ok, result}
    end
  end

  @doc """
  Creates a object.
  """
  def create(schema, attrs) do
    schema
    |> struct
    |> schema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a object.
  """
  def update(content, attrs) do
    content
    |> content.__struct__.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a object.
  """
  def delete(content), do: Repo.delete(content)

  def done(nil), do: {:error, :not_found}
  def done([]), do: {:ok, []}
  def done({n, nil}) when is_integer(n), do: {:ok, %{done: true}}
  def done(result), do: {:ok, result}
  def done(nil, _, _), do: {:error, :not_found}
  def done(result, _, _), do: {:ok, result}
  def done({:ok, _}, with: result), do: {:ok, result}
  def done(nil, :boolean), do: {:ok, false}
  def done(_, :boolean), do: {:ok, true}
  def done(nil, err_msg), do: {:error, err_msg}
  def done({:error, _}, :status), do: {:ok, %{done: false}}
end
