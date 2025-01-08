defmodule Handan.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :mobile, :string, null: false
      add :email, :string
      add :nickname, :string
      add :bio, :string
      add :avatar_url, :string
      add :hashed_password, :string, null: false
      add :confirmed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:mobile])

    create table(:users_tokens, primary_key: false) do
      add :uuid, :binary_id, primary_key: true

      add :user_uuid, references(:users, type: :binary_id, on_delete: :delete_all, column: :uuid), null: false

      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:users_tokens, [:user_uuid])
    create unique_index(:users_tokens, [:context, :token])
  end
end
