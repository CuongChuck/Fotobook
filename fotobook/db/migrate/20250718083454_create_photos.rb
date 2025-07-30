class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos do |t|
      t.string :title
      t.text :description
      t.string :image
      t.belongs_to :user, foreign_key: true
      t.belongs_to :person, foreign_key: { to_table: :users }
      t.boolean :isPublic
      t.boolean :image_processing
      t.timestamps
    end
  end
end
