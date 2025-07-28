class ChangeAlbumPhoto < ActiveRecord::Migration[7.2]
  def change
    remove_column :albums, :images
    create_table :album_has_photo, id: false do |t|
      t.bigint :album_id
      t.bigint :photo_id
    end

    add_index :album_has_photo, :album_id
    add_index :album_has_photo, :photo_id
  end
end
