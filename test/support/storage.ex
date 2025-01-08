defmodule Handan.Storage do
  @doc """
  Reset the event store and read store databases.
  """
  def reset! do
    :ok = Application.stop(:handan)

    reset_eventstore!()
    reset_readstore!()

    {:ok, _} = Application.ensure_all_started(:handan)
  end

  defp reset_eventstore! do
    {:ok, conn} =
      Handan.EventStore.config()
      |> EventStore.Config.default_postgrex_opts()
      |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn, Handan.EventStore.config())
  end

  defp reset_readstore! do
    {:ok, conn} = Postgrex.start_link(Handan.Repo.config())

    Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
    """
    TRUNCATE TABLE
      items,
      stock_uoms,
      stock_items,
      uoms,
      companies,
      warehouses,
      customers,
      sales_orders,
      sales_order_items,
      delivery_notes,
      delivery_note_items,
      sales_invoices,
      users,
      users_tokens,
      suppliers,
      projection_versions
    RESTART IDENTITY;
    """
  end
end
