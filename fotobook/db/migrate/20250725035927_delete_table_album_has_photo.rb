class DeleteTableAlbumHasPhoto < ActiveRecord::Migration[8.0]
  def change
    drop_table :album_has_photo
  end
end
