require 'test_helper'

class FollowingRelationTest < ActiveSupport::TestCase

  def setup
    @following_relation = FollowingRelation.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  test "should require a follower_id" do
    @following_relation.follower_id = nil
    assert_not @following_relation.valid?
  end

  test "should require a followed_id" do
    @following_relation.followed_id = nil
    assert_not @following_relation.valid?
  end
end
