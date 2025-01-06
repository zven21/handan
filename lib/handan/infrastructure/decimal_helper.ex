defmodule Handan.Infrastructure.DecimalHelper do
  @moduledoc false

  require Decimal
  alias Decimal, as: D

  def to_decimal(nil), do: nil
  def to_decimal(number) when is_integer(number), do: D.new(number)
  def to_decimal(number) when is_float(number), do: D.from_float(number)
  def to_decimal(number) when is_binary(number), do: D.new(number)

  def to_decimal(number) do
    case Decimal.is_decimal(number) do
      true -> number
      false -> nil
    end
  end
end
