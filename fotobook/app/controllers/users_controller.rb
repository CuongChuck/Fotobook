class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  authorize_resource

  def current_ability
    @current_ability ||= UserAbility.new(current_user)
  end

  # GET /users or /users.json
  def index
    @users = User.all.page(params[:page]).per(40)
  end

  # GET /users/1 or /users/1.json
  def show
    if request.path == photos_path
      render "show", locals: { page: "photos" }
    elsif request.path.include?(t('path.albums'))
      render "show", locals: { page: "albums" }
    elsif request.path == followings_path
      render "show", locals: { page: "followings" }
    elsif request.path == followers_path
      render "show", locals: { page: "followers" }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    file = params[:user][:avatar]
    if file
      photo = Photo.new(
        image: file,
        user_id: @user.id,
        person_id: @user.id,
        isPublic: false
      )
      if @user.avatar
        @user.avatar.remove_image!
        @user.save
      end
      if photo.save
        @user.avatar = photo
      else
        render :edit, status: :unprocessable_entity, alert: "Failed to update avatar." and return
      end
    end
    if @user.update(
      fname: params[:user][:fname],
      lname: params[:user][:lname],
      email: params[:user][:email],
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation],
      isActive: params[:user][:isActive] == "1" ? true : false,
    )
      redirect_to users_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity, alert: "Failed to update user."
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.albums.each do |album|
      album.destroy!
    end
    @user.photos.each do |photo|
      photo.destroy!
    end
    if @user.avatar
      @user.avatar.remove_image!
      @user.save
    end
    if @user.destroy!
      redirect_to users_path, status: :see_other, notice: "User was successfully destroyed."
    else
      redirect_to users_path, status: :see_other, alert: "User was NOT successfully destroyed."
    end
  end

  private
    def set_user
      if params[:user_id]
        @user = User.find(params[:user_id])
      else
        @user = User.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end

    def authenticate_admin
      if user_signed_in?
        unless current_user.isAdmin
          redirect_to user_root_path, alert: "Access denied."
        end
      else
        redirect_to root_path, alert: "Access denied."
      end
    end
end
