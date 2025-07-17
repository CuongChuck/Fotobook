class GuestController < ApplicationController
    def photo
        @photos = Photo.includes(:user, :user_like_photo).where('isPublic = ?', true)
        render "photos/index", locals: { follow: false }
    end

    def login
        render "guest/login"
    end

    def signup
        render "guest/signup"
    end

    def album
        @albums = Album.includes(:user, :photos, :user_like_album).where('isPublic = ?', true)
        render "albums/index", locals: { follow: false }
    end
end