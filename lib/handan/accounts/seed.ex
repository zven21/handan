defmodule Handan.Accounts.Seed do
  @moduledoc false

  alias Handan.Dispatcher

  def register_user(:admin) do
    request = %{
      user_uuid: Ecto.UUID.generate(),
      email: "admin@handan.com",
      nickname: "管理员",
      avatar_url: "/avatar/avatar_1.png",
      password: "123123123"
    }

    Dispatcher.run(request, :register_user)
  end
end
