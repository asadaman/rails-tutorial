class CreateFollowingRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :following_relations do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :following_relations, :follower_id
    add_index :following_relations, :followed_id
    add_index :following_relations, [:follower_id, :followed_id], unique: true
  end
end
