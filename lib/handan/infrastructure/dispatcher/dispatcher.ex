defmodule Handan.Dispatcher do
  @moduledoc false
  require Logger

  import Handan.Dispatcher.Matcher

  alias Handan.{Turbo, EventApp}
  alias Handan.Dispatcher.Matcher

  @doc """
  dispatcher for command
  """
  def run(request, command, opts \\ []) do
    Logger.info("dispatcher: #{inspect(request)}", context: :dispatcher)

    with %Matcher{} = info <- match(command),
         {:ok, valid_command} <- info.command.new(request),
         :ok <- EventApp.dispatch(valid_command, opts) do
      case info.result_type do
        nil ->
          :ok

        primary_key when is_atom(primary_key) ->
          Turbo.get(info.projection, Map.get(valid_command, primary_key), preload: info.preload)

        func when is_function(func) ->
          func.(valid_command, info)
      end
    end
  end
end
