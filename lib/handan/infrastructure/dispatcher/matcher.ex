defmodule Handan.Dispatcher.Matcher do
  @moduledoc false

  @type t :: %__MODULE__{
          command: any(),
          projection: any(),
          preload: [any()],
          result_type: any()
        }

  defstruct command: nil,
            projection: nil,
            preload: [],
            result_type: nil

  require Logger

  def match(:create_item) do
    %__MODULE__{
      command: Handan.Stock.Commands.CreateItem,
      projection: Handan.Stock.Projections.Item,
      result_type: :item_uuid,
      preload: []
    }
  end

  def match(:delete_item) do
    %__MODULE__{
      command: Handan.Stock.Commands.DeleteItem,
      projection: Handan.Stock.Projections.Item
    }
  end

  def match(_), do: {:error, :not_match}
end
