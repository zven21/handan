defmodule Handan.Repo.Migrations.CreateBomProcesses do
  use Ecto.Migration

  def change do
    create table(:bom_processes, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :bom_uuid, :binary_id
      add :process_uuid, :binary_id
      add :process_name, :string
      add :position, :integer
      add :tool_required, :string
      # add :workstation_uuid, :string

      timestamps(type: :utc_datetime)
    end

    create index(:bom_processes, [:bom_uuid, :process_uuid])
  end
end
