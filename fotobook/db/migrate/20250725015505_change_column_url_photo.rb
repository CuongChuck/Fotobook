class ChangeColumnUrlPhoto < ActiveRecord::Migration[8.0]
  def change
    rename_column(:photos, :url, :image)
    add_column(:photos, :image_processing, :boolean)
  end
end
