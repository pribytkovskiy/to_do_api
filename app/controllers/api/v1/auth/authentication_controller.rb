module Api
  module V1
    module Auth
      class AuthenticationController < ApplicationController
        def create
          user = User.find_by(email: params[:email])
          if user && user.authenticate(params[:password])
            auth_token = JsonWebToken.encode({user_id: user.id})
            render json: {auth_token: auth_token}, status: :ok
          else
            render json: {error: I18n.t('login_unsuccessfull')}, status: :unauthorized
          end
        end
      end
    end
  end
end
