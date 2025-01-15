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

  @doc "generate code"
  def generate_code(prefix) do
    prefix <> format_current_time()
  end

  defp format_current_time, do: Timex.format!(Timex.now(), "{YYYY}{0M}{0D}{h24}{0m}{0s}")
end
