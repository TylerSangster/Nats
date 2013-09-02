	require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "Does #new action work" do
    get :new
    assert_response :success
  end

  test "/new route exists" do
    assert_generates 'users/new', controller: 'users', action: 'new'
  end

  test "#create with valid attributes" do
    attributes = valid_user_attributes

    assert_difference "User.count" do
      post :create, user: attributes
    end
  end

  test "#test factory girl" do
    puts Factory(:user).first_name
  end

  test "#create with invalid attributes email" do
    attributes = invalid_user_attributes

    assert_difference "User.count", 0 do
      post :create, user: attributes
    end
  end


  def valid_user_attributes
    user = users(:tyler)

    attributes = user.attributes.except("id")
    attributes[:password] = "foo"
    attributes[:password_confirmation] = "foo"
    user.destroy!

    return attributes
  end

  def invalid_user_attributes
    user = users(:tyler)

    attributes = user.attributes.except("id")
    attributes[:email] = ""
    attributes[:password] = "foo"
    attributes[:password_confirmation] = "foo"
    user.destroy!

    return attributes
  end

end
