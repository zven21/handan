defmodule Handan.EventStoreInitial do
  def init_event_store do
    {:ok, _} = Application.ensure_all_started(:postgrex)
    # {:ok, _} = Application.ensure_all_started(:ssl)
    {:ok, _} = Application.ensure_all_started(:handan)

    config = Handan.EventStore.config()

    :ok = EventStore.Tasks.Create.exec(config, [])
    :ok = EventStore.Tasks.Init.exec(config, [])
  end
end

# ./bin/handan eval "Handan.EventStoreInitial.init_event_store()"
