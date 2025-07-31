class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show edit update destroy ]
  authorize_resource

  def current_ability
    @current_ability ||= PhotoAbility.new(current_user)
  end

  # GET /photos or /photos.json
  def index
    if user_signed_in?
      if request.path == root_path && params[:page].blank?
        if current_user.isAdmin?
          redirect_to admin_root_path
        else
          redirect_to user_root_path
        end
      end
      if current_user.isAdmin?
        @photos = Photo.photo_only.select(:title, :image, :id, :user_id).page(params[:page]).per(40)
      else
        if request.path != user_root_path
          @photos = Photo.photo_only.include_likes.include_users.public_only
        else
          @photos = Photo.photo_only.include_likes.include_users.where(user_id: current_user.followees.select(:id)).public_only.or(Photo.include_likes.include_users.where(user_id: current_user.id).photo_only)
          render "index", locals: { feed: true }
        end
      end
    else
      @photos = Photo.photo_only.include_likes.include_users.public_only
    end
  end

  def search
    input = params[:search]
    @photos = Photo.photo_only.include_likes.include_users.public_only.where("title LIKE ? OR description LIKE ?", "%#{input}%", "%#{input}%")
    render "index"
  end

  # GET /photos/1 or /photos/1.json
  def show
  end

  # GET /photos/new
  def new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos or /photos.json
  def create
    file = params[:photo][:image]
    unless file
      render :new, status: :unprocessable_entity, alert: "Photo was not uploaded successfully."
    end

    @photo = Photo.new(
      title: params[:photo][:title],
      description: params[:photo][:description],
      image: file,
      user_id: current_user.id,
      isPublic: params[:photo][:sharing_mode] == "1" ? true : false
    )

    if @photo.save
      redirect_to "#{t('path.users')}/#{current_user.id}#{t('path.photos')}", notice: "Photo was successfully created."
    else
      render :new, status: :unprocessable_entity, alert: "Photo was not created."
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    file = params[:photo][:image]
    if file
      @photo.remove_image!
      @photo.save
      @photo.image = file
    end

    if @photo.update(
      title: params[:photo][:title],
      description: params[:photo][:description],
      isPublic: params[:photo][:isPublic] == "1" ? true : false
    )
      if current_user.isAdmin
        redirect_to admin_root_path, notice: "Photo was successfully updated."
      else
        redirect_to "#{t('path.users')}/#{current_user.id}#{t('path.photos')}", notice: "Photo was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity, alert: "Photo was not updated."
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    if @photo.destroy!
      if current_user.isAdmin
        redirect_to admin_root_path, notice: "Photo was successfully removed."
      else
        redirect_to "#{t('path.users')}/#{current_user.id}#{t('path.photos')}", status: :see_other, notice: "Photo was successfully removed."
      end
    else
      render :edit, status: :unprocessable_entity, alert: "Photo was not removed."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.fetch(:photo, {})
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
