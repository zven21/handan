defmodule HandanWeb.GraphQL.Resolvers.Accounts do
  @moduledoc false

  alias Handan.Accounts

  def login(_, %{request: request}, _) do
    with {:ok, %{user: user, token: token}} <- Accounts.login(request) do
      {:ok, Map.put(user, :access_token, token)}
    else
      # {:error, [message: "login failed", code: ecode(:create_fails)]}
      _ -> {:error, "login failed"}
    end
  end

  @doc "get current user"
  def get_current_user(_, %{context: %{current_user: current_user}}), do: {:ok, current_user}
end
