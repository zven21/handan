defmodule Handan.Accounts.UserTest do
  @moduledoc """
  Test for user
  """

  use Handan.DataCase
  alias Handan.Dispatcher

  describe "register user" do
    test "should succeed with valid request" do
      request = build(:user, email: "test@example.com", nickname: "test")

      {:ok, %{user: user}} = Dispatcher.run(request, :register_user)

      assert user.email == request.email
      assert user.nickname == request.nickname
    end

    test "with invalid email data" do
      request = build(:user, email: "invalid-email")
      assert {:error, %{email: ["must have the correct format"]}} = Dispatcher.run(request, :register_user)
    end

    test "with email == nil data" do
      request = build(:user, email: nil)
      assert {:error, %{email: ["can't be blank"]}} = Dispatcher.run(request, :register_user)
    end

    test "with unique" do
      request_1 = build(:user, email: "test@example.com")
      request_2 = build(:user, email: "test@example.com")

      _ = Dispatcher.run(request_1, :register_user)

      assert {:error, %{email: "has already taken"}} = Dispatcher.run(request_2, :register_user)
    end
  end

  describe "login" do
    setup do
      user = fixture(:user, %{email: "test@example.com", password: "123123123"})
      [user: user]
    end

    test "should succeed with valid request" do
      request = %{
        email: "test@example.com",
        password: "123123123"
      }

      {:ok, %{user: user, token: _token}} = Handan.Accounts.login(request)
      assert user.email == request.email
    end

    test "should fail with invalid request" do
      request = %{
        email: "test@example.com",
        password: "error"
      }

      assert {:error, :invalid_email_or_password} = Handan.Accounts.login(request)
    end
  end
end
