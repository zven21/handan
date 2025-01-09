defmodule HandanWeb.GraphQL.Middlewares.Authorize do
  @moduledoc """
  authorize gateway, mainly for login check
  """

  @behaviour Absinthe.Middleware

  import HandanWeb.GraphQL.Helpers.Utils, only: [handle_absinthe_error: 3]
  import HandanWeb.GraphQL.Helpers.ErrorCode, only: [ecode: 1]

  # logined_user
  def call(%{context: %{current_user: current_user}} = resolution, :user) when not is_nil(current_user), do: resolution

  def call(resolution, _info) do
    resolution
    |> handle_absinthe_error("pls login first", ecode(:unauthenticated))
  end
end
