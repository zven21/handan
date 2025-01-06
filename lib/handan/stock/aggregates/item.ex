defmodule Handan.Stock.Aggregates.Item do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :item_uuid, Ecto.UUID
    field :name, :string
    field :selling_price, :decimal
    field :description, :string
    field :deleted?, :boolean, default: false
  end

  alias Handan.Stock.Commands.{
    CreateItem,
    DeleteItem
  }

  alias Handan.Stock.Events.{
    ItemCreated,
    ItemDeleted
  }

  @doc """
  Stop the item aggregate after it has been deleted
  """
  def after_event(%ItemDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # create item
  def execute(%__MODULE__{item_uuid: nil}, %CreateItem{} = cmd) do
    item_evt = %ItemCreated{
      item_uuid: cmd.item_uuid,
      name: cmd.name,
      selling_price: cmd.selling_price,
      description: cmd.description
    }

    [item_evt] |> List.flatten()
  end

  def execute(_, %CreateItem{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{item_uuid: item_uuid} = _state, %DeleteItem{item_uuid: item_uuid} = _cmd) do
    %ItemDeleted{
      item_uuid: item_uuid
    }
  end

  def execute(_, %DeleteItem{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %ItemCreated{} = evt) do
    %__MODULE__{
      state
      | item_uuid: evt.item_uuid,
        name: evt.name,
        selling_price: evt.selling_price
    }
  end

  def apply(%__MODULE__{} = state, %ItemDeleted{} = _evt) do
    %__MODULE__{
      state
      | deleted?: true
    }
  end
end
