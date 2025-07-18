class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname, :password])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fname, :lname, :password])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User)
        resource.isAdmin? ? admin_root_path : user_root_path
      else
        super
      end
  end
end
