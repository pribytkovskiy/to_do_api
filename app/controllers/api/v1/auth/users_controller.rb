module Api
  module V1
    module Auth
      class UsersController < ApplicationController
        def create
          user = User.new(user_params)
          if user.save
            render json: { message: I18n.t('user_created_successfully') },
                  status: :created
          else
            render json: { errors: user.errors.full_messages },
                  status: :bad_request
          end
        end

        private

        def user_params
          params.require(:user)
                .permit(:email,
                        :password,
                        :password_confirmation)
        end
      end
    end
  end
end
