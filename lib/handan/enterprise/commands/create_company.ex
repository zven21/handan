defmodule Handan.Enterprise.Commands.CreateCompany do
  @moduledoc false

  @required_fields ~w(company_uuid name)a

  use Handan.EventSourcing.Command

  defcommand do
    field :company_uuid, Ecto.UUID
    field :user_uuid, Ecto.UUID
    field :user_email, :string
    field :name, :string
    field :description, :string
    field :logo_url, :string
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Enterprise.Commands.CreateCompany

    def enrich(%CreateCompany{user_uuid: user_uuid} = cmd, _) do
      handle_user_fn = fn cmd ->
        case Handan.Accounts.get_user(user_uuid) do
          {:error, _} ->
            %{cmd | user_uuid: nil}

          {:ok, user} ->
            %{cmd | user_uuid: user_uuid, user_email: user.email}
        end
      end

      cmd
      |> handle_user_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{user_uuid: nil} ->
          {:error, %{user: "not found"}}

        _ ->
          {:ok, cmd}
      end
    end
  end
end
