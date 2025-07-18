class CreateUser1FollowUser2JoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :user1_follow_user2, id: false do |t|
      t.bigint :follower_id, null: false
      t.bigint :followee_id, null: false
    end

    add_index :user1_follow_user2, :follower_id
    add_index :user1_follow_user2, :followee_id
  end
end
