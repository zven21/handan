defmodule Handan.Enterprise.Seed do
  @moduledoc false

  alias Handan.Dispatcher

  @doc "create company"
  def create_company(user_uuid) do
    request = %{
      company_uuid: Ecto.UUID.generate(),
      user_uuid: user_uuid,
      name: "Handan",
      description: "Handan",
      logo_url: "/avatar/avatar_1.png"
    }

    Dispatcher.run(request, :create_company)
  end
end
