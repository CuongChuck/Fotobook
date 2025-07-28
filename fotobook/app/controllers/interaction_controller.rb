class InteractionController < ApplicationController
    before_action :authenticate_normal_user

    def follow
        user = User.find(params[:id])
        unless current_user.followees.include?(user)
            current_user.followees << user
        end
        current_user.save
        render turbo_stream: turbo_stream.replace_all(".follow-button-#{user.id}", partial: "application/follow", locals: { user: user })
    end

    def unfollow
        user = User.find(params[:id])
        if current_user.followees.include?(user)
            current_user.followees.delete(user)
        end
        current_user.save
        render turbo_stream: turbo_stream.replace_all(".follow-button-#{user.id}", partial: "application/follow", locals: { user: user })
    end

    def unfollow_profile
        @user = User.find(params[:id])
        if current_user.followees.include?(@user)
            current_user.followees.delete(@user)
        end
        current_user.save
        render turbo_stream: turbo_stream.update(@user, partial: "application/profile_follow", locals: { user: @user })
    end

    def like_photo
        photo = Photo.find(params[:id])
        unless current_user.liked_photos.include?(photo)
            current_user.liked_photos << photo
        end
        current_user.save
        render turbo_stream: turbo_stream.update(photo, partial: "application/like", locals: { photo: photo })
    end

    def unlike_photo
        photo = Photo.find(params[:id])
        if current_user.liked_photos.include?(photo)
            current_user.liked_photos.delete(photo)
        end
        current_user.save
        render turbo_stream: turbo_stream.update(photo, partial: "application/like", locals: { photo: photo })
    end

    def like_album
        album = Album.find(params[:id])
        unless current_user.liked_albums.include?(album)
            current_user.liked_albums << album
        end
        current_user.save
        render turbo_stream: turbo_stream.update(album, partial: "application/like", locals: { album: album })
    end

    def unlike_album
        album = Album.find(params[:id])
        if current_user.liked_albums.include?(album)
            current_user.liked_albums.delete(album)
        end
        current_user.save
        render turbo_stream: turbo_stream.update(album, partial: "application/like", locals: { album: album })
    end

    private

    def authenticate_normal_user
      if user_signed_in?
        if current_user.isAdmin
          redirect_to admin_root_path, alert: "Access denied."
        end
      else
        redirect_to root_path, alert: "Access denied."
      end
    end
end
