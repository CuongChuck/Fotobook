class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :set_devise_mapping
  before_action :authenticate_user!

  def update
    self.resource = User.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if params[:user][:password].present? && params[:user][:password_confirmation].present? && params[:user][:current_password].present?
      if resource.update_with_password(current_password: params[:user][:current_password], password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
        bypass_sign_in resource
        redirect_to after_update_path_for(resource), notice: 'Password updated successfully.'
      else
        flash[:now] = resource.errors.full_messages.join(', ')
        render :edit, status: :unprocessable_entity
      end
    elsif params[:user][:fname].present? || params[:user][:lname].present? || params[:user][:email].present?
      file = params[:user][:avatar]
      if file
        photo = Photo.new(
          image: file,
          user_id: current_user.id,
          person_id: current_user.id,
          isPublic: false
        )
        unless photo.save
          flash[:now] = photo.errors.full_messages.join(', ')
          render :edit, status: :unprocessable_entity and return
        end
      end
      if resource.update_without_password(fname: params[:user][:fname], lname: params[:user][:lname], email: params[:user][:email])
        redirect_to after_update_path_for(resource), notice: 'Profile updated successfully.'
      else
        flash[:now] = resource.errors.full_messages.join(', ')
        render :edit, status: :unprocessable_entity  and return
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
