class AddImagesToAlbums < ActiveRecord::Migration[8.0]
  def change
    add_column :albums, :images, :json
  end
end
