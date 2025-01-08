defmodule Handan.Production.Commands.CreateWorkstation do
  @moduledoc """
  创建工作站的命令。
  """

  @required_fields ~w(workstation_uuid name)a

  use Handan.EventSourcing.Command

  defcommand do
    field :workstation_uuid, Ecto.UUID
    field :name, :string
  end
end
