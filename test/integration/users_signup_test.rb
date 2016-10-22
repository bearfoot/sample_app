require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path

    assert_select "form[action=?]", "/users"

    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "",
                                       email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "foo"}}
    end

    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
    assert_select "div[id=error_explanation]" do
      assert_select "li", count: 3
    end
    assert_select "div[id=error_explanation]"

    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "Joe",
                                       email: "user@valid.com",
                                       password: "123456",
                                       password_confirmation: "different"}}
    end
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
    assert_select "div[id=error_explanation]" do
      assert_select "li", count: 1
    end
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_select 'div[class="alert alert-success"]', count: 1, text: "Welcome to the Sample App!"
    assert_select "section[class=user_info]", count: 1
    assert_template 'users/show'
    assert is_logged_in?
  end

end
