class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :set_devise_mapping
  before_action :authenticate_user!

  def update
    self.resource = User.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if params[:user][:password].present? && params[:user][:password_confirmation].present? && params[:user][:current_password].present?
      if resource.update_with_password(user_params)
        bypass_sign_in resource
        redirect_to after_update_path_for(resource), notice: 'Password updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    elsif params[:user][:fname].present? || params[:user][:lname].present? || params[:user][:email].present?
      if params[:user][:avatar]
        file = params[:user][:avatar]
        if file
          result = Cloudinary::Uploader.upload(file.path, folder: "#{current_user.id}/photos", transformation: [{ width: 200, crop: :fill }])
          url = result['secure_url']
        end

        @photo = Photo.new(
          url: url,
          user_id: current_user.id,
          person_id: current_user.id,
          isPublic: false
        )

        unless @photo.save
          @photo.errors.full_messages.each do |msg|
            render html: msg, status: :unprocessable_entity and return
          end
        end
      end
      if resource.update(fname: params[:user][:fname], lname: params[:user][:lname], email: params[:user][:email])
        redirect_to after_update_path_for(resource), notice: 'Profile updated successfully.'
      else
        render :edit, status: :unprocessable_entity and return
      end
    else
      redirect_to after_update_path_for(resource), notice: 'No valid changes made.'
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :fname, :lname, :email, :password, :password_confirmation, :current_password
    ])
  end

  def after_update_path_for(resource)
    "#{t('path.users')}/#{resource.id}#{t('path.photos')}"
  end

  private
  def set_devise_mapping
    request.env["devise.mapping"] = Devise.mappings[:user]
  end
end
