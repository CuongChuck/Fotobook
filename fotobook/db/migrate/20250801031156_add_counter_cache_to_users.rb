class AddCounterCacheToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :photos_count, :integer, default: 0
    add_column :users, :albums_count, :integer, default: 0

    User.find_each do |user|
      User.reset_counters(user.id, :photos)
      User.reset_counters(user.id, :albums)
    end
  end
end
