defmodule HandanWeb.GraphQL.Helpers.Fields do
  @moduledoc false

  defmacro timestamp_fields do
    quote do
      field(:inserted_at, :datetime)
      field(:updated_at, :datetime)
    end
  end

  defmacro pagination_args do
    quote do
      field(:page, :integer, default_value: 1)
      field(:size, :integer, default_value: 20)
    end
  end

  defmacro query_args do
    quote do
      field :nonce, :integer
      field :when, :when_enum
      field :sort, :sort_enum
      field :first, :integer
      field :date_range, list_of(:date)
      field :stat_date_range, list_of(:date)
    end
  end

  @doc """
  general pagination fields except entries
  """
  defmacro pagination_fields do
    quote do
      field(:total_entries, :integer)
      field(:page_size, :integer)
      field(:total_pages, :integer)
      field(:page_number, :integer)
    end
  end
end
