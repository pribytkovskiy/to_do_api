# frozen_string_literal: true

class ApplicationController < ActionController::API
  protected
  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload.first)
      return invalid_authentication
    end
  
    current_user
    invalid_authentication unless @current_user
  end
  
  def invalid_authentication
    render json: { error: I18n.t('invalid_request') }, status: :unauthorized
  end
  
  private
  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  rescue
    nil
  end
  
  def current_user
    @current_user ||= User.find_by(id: payload[0]['user_id']) if payload
  end
end
