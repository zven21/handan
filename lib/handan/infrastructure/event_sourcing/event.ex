defmodule Handan.EventSourcing.Event do
  @moduledoc """
  Adds the macro `defevent` which is used to define a new event.
  """

  import Handan.EventSourcing.Type, only: [deftype: 1]

  defmacro defevent(opts \\ [], do: block) do
    quote do
      @version Keyword.get(unquote(opts), :version, 1)

      deftype do
        field :version, :integer, default: @version

        # operation logs
        # field :item_uuid, Ecto.UUID
        # field :item_type, :string

        # store
        # field :store_uuid, Ecto.UUID
        # field :user_uuid, Ecto.UUID

        unquote(block)
      end

      def upcast(params, metadata) do
        params
        |> Map.put_new("version", 1)
        |> upcast_params(metadata)
      end

      defp upcast_params(%{"version" => @version} = params, _) do
        params
      end

      defp upcast_params(%{"version" => version} = params, metadata) do
        params
        |> upcast(metadata, version + 1)
        |> Map.put("version", version + 1)
        |> upcast_params(metadata)
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      @required_fields nil

      use Handan.EventSourcing.Type
      import Handan.EventSourcing.Event

      def upcast(params, _, 1), do: params
    end
  end
end
