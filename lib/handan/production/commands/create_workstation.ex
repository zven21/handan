defmodule Handan.Production.Commands.CreateWorkstation do
  @moduledoc """
  创建工作站的命令。
  """

  @required_fields ~w(workstation_uuid name)a

  use Handan.EventSourcing.Command

  defcommand do
    field :workstation_uuid, Ecto.UUID
    field :name, :string
    field :admin_uuid, Ecto.UUID
    field :member_ids, {:array, Ecto.UUID}, default: []
    field :members, {:array, :map}, default: []
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Enterprise
    alias Handan.Production.Commands.CreateWorkstation

    def enrich(%CreateWorkstation{} = cmd, _) do
      handle_member_fn = fn cmd ->
        updated_members =
          cmd.member_ids
          |> Enum.map(fn member_id ->
            case Enterprise.get_staff(member_id) do
              {:ok, staff} ->
                %{
                  staff_uuid: staff.uuid,
                  staff_name: staff.name,
                  staff_email: staff.email
                }

              _ ->
                nil
            end
          end)
          |> Enum.filter(& &1)

        %{cmd | members: updated_members}
      end

      cmd
      |> handle_member_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{members: members} ->
          members
          |> Enum.all?(fn member -> member.staff_uuid != nil end)
          |> case do
            true -> {:ok, cmd}
            false -> {:error, %{member: "not found"}}
          end

        _ ->
          {:ok, cmd}
      end
    end
  end
end
