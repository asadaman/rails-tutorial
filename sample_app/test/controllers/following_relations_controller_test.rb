require 'test_helper'

class FollowingRelationsControllerTest < ActionDispatch::IntegrationTest

  test "create should require logged-in user" do
    assert_no_difference 'FollowingRelation.count' do
      post following_relations_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'FollowingRelation.count' do
      delete following_relation_path(following_relations(:one))
    end
    assert_redirected_to login_url
  end
end
