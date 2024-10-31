class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include Pagy::Backend
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access denied: #{exception.message}"
    redirect_to root_path # or any other path you want to redirect to
  end
end
