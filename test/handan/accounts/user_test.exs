defmodule Handan.Accounts.UserTest do
  @moduledoc """
  Test for user
  """

  use Handan.DataCase
  alias Handan.Dispatcher

  describe "register user" do
    test "should succeed with valid request" do
      request = build(:user, mobile: "18612312312", nickname: "test")

      {:ok, %{user: user}} = Dispatcher.run(request, :register_user)

      assert user.mobile == request.mobile
      assert user.nickname == request.nickname
    end

    test "with invalid mobile data" do
      request = build(:user, mobile: "invalid-mobile")
      assert {:error, %{mobile: ["must have the correct format"]}} = Dispatcher.run(request, :register_user)
    end

    test "with mobile == nil data" do
      request = build(:user, mobile: nil)
      assert {:error, %{mobile: ["can't be blank"]}} = Dispatcher.run(request, :register_user)
    end

    test "with unique" do
      request_1 = build(:user, mobile: "18612312312")
      request_2 = build(:user, mobile: "18612312312")

      _ = Dispatcher.run(request_1, :register_user)

      assert {:error, %{mobile: "has already taken"}} = Dispatcher.run(request_2, :register_user)
    end
  end

  describe "login" do
    setup do
      user = fixture(:user, %{mobile: "18612312312", password: "123123123"})
      [user: user]
    end

    test "should succeed with valid request" do
      request = %{
        mobile: "18612312312",
        password: "123123123"
      }

      {:ok, %{user: user, token: _token}} = Handan.Accounts.login(request)
      assert user.mobile == request.mobile
    end

    test "should fail with invalid request" do
      request = %{
        mobile: "18612312312",
        password: "error"
      }

      assert {:error, :invalid_mobile_or_password} = Handan.Accounts.login(request)
    end
  end
end
