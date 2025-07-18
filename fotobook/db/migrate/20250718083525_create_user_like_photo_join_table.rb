class CreateUserLikePhotoJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :user_like_photo, id: false do |t|
      t.bigint :user_id
      t.bigint :photo_id
    end

    add_index :user_like_photo, :user_id
    add_index :user_like_photo, :photo_id
  end
end
