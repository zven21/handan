defmodule Handan.Fixture do
  @moduledoc false

  import Handan.Factory

  alias Handan.Dispatcher

  def create_item(_) do
    {:ok, item} = fixture(:item, name: "item-name")

    [
      item: item
    ]
  end

  def fixture(:item, attrs), do: Dispatcher.run(build(:item, attrs), :create_item)
end
