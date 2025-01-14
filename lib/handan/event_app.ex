defmodule Handan.EventApp do
  @moduledoc false

  use Commanded.Application,
    otp_app: :handan,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Handan.EventStore
    ]

  router(Handan.EventRouter)

  defimpl Jason.Encoder, for: [MapSet, Range, Stream] do
    def encode(struct, opts) do
      Jason.Encode.list(Enum.to_list(struct), opts)
    end
  end

  # warning: redefining module Jason.Encoder.Decimal (current version loaded from _build/test/lib/jason/ebin/Elixir.Jason.Encoder.Decimal.beam)
  defimpl Jason.Encoder, for: Decimal do
    def encode(decimal, opts) do
      Jason.Encode.string(Decimal.to_string(decimal), opts)
    end
  end

  defimpl Jason.Encoder, for: Function do
    def encode(data, options) when is_function(data) do
      {:arity, arity} = Function.info(data, :arity)

      Jason.Encode.string("Function/#{arity}", options)
    end
  end
end
