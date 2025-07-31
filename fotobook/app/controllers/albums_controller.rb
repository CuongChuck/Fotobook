class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  authorize_resource

  def current_ability
    @current_ability ||= AlbumAbility.new(current_user)
  end

  # GET /albums or /albums.json
  def index
    if user_signed_in?
      if current_user.isAdmin?
        @albums = Album.include_photos.page(params[:page]).per(40)
      else
        if request.path.include?("/discover")
          @albums = Album.include_photos.include_likes.include_users.public_only
        else
          @albums = Album.include_photos.include_likes.includes(user: [:followees]).where(user_id: current_user.followees.select(:id)).public_only.or(Album.include_photos.include_likes.includes(user: [:followees]).where(user_id: current_user.id))
          render "index", locals: { feed: true }
        end
      end
    else
      @albums = Album.include_photos.include_likes.include_users.public_only
    end
  end

  def search
    input = params[:search]
    @albums = Album.include_photos.include_likes.include_users.public_only.where("title LIKE ? OR description LIKE ?", "%#{input}%", "%#{input}%")
    render "index"
  end

  # GET /albums/1 or /albums/1.json
  def show
  end

  # GET /albums/new
  def new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    @album = Album.new(
      title: params[:album][:title],
      description: params[:album][:description],
      isPublic: params[:album][:isPublic] == "1" ? true : false,
      user_id: current_user.id
    )
    if @album.save
      files = params[:album][:images]
      if files
        files.each do |file|
          photo = Photo.new(image: file, isPublic: false, user_id: current_user.id)
          photo.albums << @album
          photo.save
        end
        if @album.save
          redirect_to "#{t('path.users')}/#{current_user.id}#{t('path.albums')}", notice: "Album was successfully created."
        else
          alert_error(:new)
        end
      else
        alert_error(:new)
      end
    else
      alert_error(:new)
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    new_images = params[:album][:new_images]
    remove_images = params[:album][:remove_images]
    remove_size = remove_images ? remove_images.length : 0
    # raise "Check params"
    if @album.photos.size - remove_size + new_images.length - 1 < 1
      redirect_to edit_user_album_path(current_user.id, @album.id), alert: "Album must have images." and return
    end
    if remove_images.present?
      remove_images.each do |i|
        photo = @album.photos.find(i)
        if photo.title || photo.person_id
          @album.photos.delete(photo)
        else
          photo.destroy!
        end
      end
    end

    if new_images.present?
      new_images.each do |image|
        photo = Photo.new(image: image, isPublic: false, user_id: current_user.id)
        photo.albums << @album
        photo.save
      end
    end

    if @album.update(
      title: params[:album][:title],
      description: params[:album][:description],
      isPublic: params[:album][:isPublic] == "1" ? true : false
    )
      if current_user.isAdmin
        redirect_to albums_path, notice: "Album was successfully updated."
      else
        redirect_to "#{t('path.users')}/#{current_user.id}#{t('path.albums')}", notice: "Album was successfully updated."
      end
    else
      alert_error(:edit)
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.photos.each do |photo|
      unless photo.title || photo.person_id
        photo.destroy!
      end
    end
    if @album.destroy!
      if current_user.isAdmin
        redirect_to albums_path, notice: "Album was successfully removed."
      else
        redirect_to "#{t('path.users')}/#{current_user.id}#{t('path.albums')}", status: :see_other, notice: "Album was successfully removed."
      end
    else
      redirect_to "#{t('path.users')}/#{current_user.id}#{t('path.albums')}", status: :see_other, alert: "Album was NOT successfully removed."
    end
  end

  private

    def set_album
      @album = Album.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:title, :description, :isPublic, {images: []}, remove_images: [])
    end

    def alert_error(page)
      render page, status: :unprocessable_entity, alert: "Error in #{page == :new ? "creating" : "editing"} a new album."
    end

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
