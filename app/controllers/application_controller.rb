class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Helpers
  helper_method :current_user

  def current_user
    @current_user ||= current_api_v1_user
  end
end
