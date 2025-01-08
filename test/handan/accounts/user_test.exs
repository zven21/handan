defmodule Handan.Accounts.UserTest do
  @moduledoc """
  Test for user
  """

  use Handan.DataCase

  describe "register user" do
    test "should succeed with valid request" do
      request = build(:user, mobile: "18612312312", nickname: "test")

      {:ok, %{user: user}} = Dispatcher.run(request, :register_user)

      assert user.mobile == request.mobile
      assert user.nickname == request.nickname
    end

    # test "with invalid mobile data" do
    #   request = build(:user, mobile: "invalid-mobile")
    #   assert {:error, %{mobile: ["must have the correct format"]}} = Dispatcher.run(request, :register_user)
    # end

    # test "with mobile == nil data" do
    #   request = build(:user, mobile: nil)
    #   assert {:error, %{mobile: ["can't be blank"]}} = Dispatcher.run(request, :register_user)
    # end

    # test "with unique" do
    #   request_1 = build(:user, mobile: "18612312312")
    #   request_2 = build(:user, mobile: "18612312312")

    #   _ = Dispatcher.run(request_1, :register_user)
    #   assert {:error, %{mobile: "has already taken"}} = Dispatcher.run(request_2, :register_user)
    # end
  end
end
