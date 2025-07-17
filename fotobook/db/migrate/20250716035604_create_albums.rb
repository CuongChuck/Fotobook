class CreateAlbums < ActiveRecord::Migration[8.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.belongs_to :user, foreign_key: true
      t.boolean :isPublic
      t.timestamps
    end
  end
end
