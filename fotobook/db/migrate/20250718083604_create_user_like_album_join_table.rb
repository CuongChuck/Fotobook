class CreateUserLikeAlbumJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :user_like_album, id: false do |t|
      t.bigint :user_id
      t.bigint :album_id
    end

    add_index :user_like_album, :user_id
    add_index :user_like_album, :album_id
  end
end
