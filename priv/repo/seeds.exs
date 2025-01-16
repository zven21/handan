# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Handan.Repo.insert!(%Handan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seeds do
  def server_initital_data() do
    {:ok, %{user: %{uuid: admin_uuid}}} = Handan.Accounts.Seed.register_user(:admin)
    {:ok, company} = Handan.Enterprise.Seed.create_company(admin_uuid)
  end
end

Seeds.server_initital_data()
