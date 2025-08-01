class Photo < ApplicationRecord
    default_scope { order(created_at: :desc) }

    scope :include_likes, -> { includes(:user_like_photo) }
    scope :public_only, -> { where(isPublic: true) }
    scope :include_users, -> { includes(user: [:avatar]) }
    scope :photo_only, -> { where.not(title: nil) }

    mount_uploader :image, ImageUploader

    has_and_belongs_to_many :albums, join_table: "album_has_photo"
    has_and_belongs_to_many :user_like_photo, class_name: "User", join_table: "user_like_photo"

    belongs_to :user, counter_cache: true
    belongs_to :person, class_name: "User", optional: true

    validates :title, length: { maximum: 140 }, presence: true, unless: -> { person_id.present? || albums.any? }
    validates :description, length: { maximum: 300 }, presence: true, unless: -> { person_id.present? || albums.any? }
    validates :image, presence: true
end
