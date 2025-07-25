class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show edit update destroy ]

  # GET /photos or /photos.json
  def index
    if user_signed_in?
      if current_user.isAdmin?
        @photos = Photo.all.select(:title, :url)
      else
        if request.path != user_root_path
          @photos = Photo.includes(:user_like_photo, :user).where(isPublic: true)
        else
          @photos = Photo.includes(:user_like_photo, user: [:followees]).where(user_id: current_user.followees.select(:id), isPublic: true)
          render "index", locals: { feed: true }
        end
      end
    else
      @photos = Photo.includes(:user_like_photo, :user).where(isPublic: true)
    end
  end

  def feed
    @photos = Photo.includes(:user_like_photo, :user).where(user_id: current_user.followees.select(:id), isPublic: true)
    render "index", locals: { feed: true }
  end

  # GET /photos/1 or /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos or /photos.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: "Photo was successfully updated." }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @photo.destroy!

    respond_to do |format|
      format.html { redirect_to photos_path, status: :see_other, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.fetch(:photo, {})
    end
end
