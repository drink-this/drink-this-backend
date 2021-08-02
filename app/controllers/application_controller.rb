class ApplicationController < ActionController::API
  helper_method :current_user
  
  def current_user
    @current_user ||= User.find(token: params[:auth_token]) if params[:auth_token]
  end
end
