class Photo < ApplicationRecord
    has_and_belongs_to_many :albums, join_table: "album_has_photo"

    has_and_belongs_to_many :user_like_photo, class_name: "User", join_table: "user_like_photo"

    belongs_to :user
    belongs_to :person, class_name: "User", optional: true

    validates :title, length: { maximum: 140 }, presence: true, unless: -> { person_id.present? || albums.any? }
    validates :description, length: { maximum: 300 }, presence: true, unless: -> { person_id.present? || albums.any? }
    validates :url, presence: true
end
