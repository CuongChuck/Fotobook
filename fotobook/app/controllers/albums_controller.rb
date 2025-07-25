class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]

  # GET /albums or /albums.json
  def index
    if user_signed_in?
      if current_user.isAdmin?
        @albums = Album.all.includes(:photos)
      else
        if request.path.include?("/discover")
          @albums = Album.includes(:photos, :user_like_album, :user).where(isPublic: true)
        else
          @albums = Album.includes(:photos, :user_like_album, user: [:followees]).where(user_id: current_user.followees.select(:id), isPublic: true)
          render "index", locals: { feed: true }
        end
      end
    else
      @albums = Album.includes(:photos, :user_like_album, :user).where(isPublic: true)
    end
  end

  # GET /albums/1 or /albums/1.json
  def show
    @albums = Album.all
  end

  def feed
    @albums = Album.includes(:user, :photos, :user_like_album).where(user_id: current_user.followees.select(:id), isPublic: true)
    render "index", locals: { feed: true }
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: "Album was successfully updated." }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.destroy!

    respond_to do |format|
      format.html { redirect_to albums_path, status: :see_other, notice: "Album was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.fetch(:album, {})
    end
end
