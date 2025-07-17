class User < ApplicationRecord
    has_one :avatar, class_name: "Photo", foreign_key: "person_id"

    has_and_belongs_to_many :followers, class_name: "User", join_table: "user1_follow_user2"
    has_and_belongs_to_many :followees, class_name: "User", join_table: "user1_follow_user2"

    has_and_belongs_to_many :liked_photos, class_name: "Photo", join_table: "user_like_photo"
    has_and_belongs_to_many :liked_albums, class_name: "Album", join_table: "user_like_album"

    has_many :photos, foreign_key: "user_id"
    has_many :albums

    validates :fname, length: { maximum: 25 }, presence: true
    validates :lname, length: { maximum: 25 }, presence: true
    validates :email, length: { maximum: 255 }, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
    validates :password, length: { maximum: 64 }, presence: true, confirmation: true
end
