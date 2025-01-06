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

  def decimal_add(nil, _), do: nil
  def decimal_add(_, nil), do: nil

  def decimal_add(number1, number2) do
    D.add(to_decimal(number1), to_decimal(number2))
  end

  def decimal_sub(nil, nil), do: nil
  def decimal_sub(nil, number), do: D.sub(to_decimal(number), to_decimal(0))
  def decimal_sub(number, nil), do: D.sub(to_decimal(number), to_decimal(0))

  def decimal_sub(number1, number2) do
    D.sub(to_decimal(number1), to_decimal(number2))
  end

  def decimal_mul(nil, nil), do: nil
  def decimal_mul(nil, number), do: number
  def decimal_mul(number, nil), do: number

  def decimal_mul(number1, number2) do
    D.mult(to_decimal(number1), to_decimal(number2))
  end

  def decimal_div(nil, nil), do: nil
  def decimal_div(nil, number), do: number
  def decimal_div(number, nil), do: number

  def decimal_div(number1, number2) do
    D.div(to_decimal(number1), to_decimal(number2))
  end
end
