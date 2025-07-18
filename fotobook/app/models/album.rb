class Album < ApplicationRecord
    has_and_belongs_to_many :photos, join_table: "album_has_photo"

    has_and_belongs_to_many :user_like_album, class_name: "User", join_table: "user_like_album"

    belongs_to :user

    validates :title, length: { maximum: 140 }, presence: true
    validates :description, length: { maximum: 300 }, presence: true
end
