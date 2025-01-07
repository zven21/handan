defmodule Handan.Infrastructure.Helper do
  @moduledoc false

  @doc "ensure atom"
  def to_atom(v) when is_atom(v), do: v
  def to_atom(v) when is_binary(v), do: String.to_existing_atom(v)

  @doc "ensure integer"
  def to_integer(id) when is_binary(id), do: String.to_integer(id)
  def to_integer(id), do: id

  def to_array(v) when v == "", do: []
  def to_array(v) when is_binary(v), do: v |> String.split(",")
  def to_array(v) when is_list(v), do: v
end
