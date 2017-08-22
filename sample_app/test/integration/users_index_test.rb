require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    activated_users ||= User.where(activated: true)
    test_for_more_than_30_activated_users if activated_users.size > 30
    # assert_select 'div.pagination' if users.size > 30
    # User.paginate(page: 1).each do |user|
    #   assert_select 'a[href=?]', user_path(user), text: user.name
    # end
  end

  private

  def test_for_more_than_30_activated_users
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

end
