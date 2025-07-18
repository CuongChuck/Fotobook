class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.boolean :isActive, default: true
      t.string :password
      t.boolean :isAdmin, default: false
      t.timestamps
    end
  end
end
