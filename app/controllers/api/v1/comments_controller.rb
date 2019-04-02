module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate_request!
      load_and_authorize_resource :task
      load_and_authorize_resource :comment, through: :task, shallow: true

      resource_description do
        short "Comment's endpoints"
        error 422, 'Unprocessable entity'
        error 401, 'Unauthorized'
        formats %w[json]
      end

      def_param_group :comment do
        param :data, Hash, required: true do
          param :attributes, Hash, required: true do
            param :text, String, required: true
            param :image, File
          end
        end
      end

      api :GET, '/v1/tasks/:task_id/comments', "Get all task's comments"
      def index
        render json: @comments, **ok
      end

      api :POST, '/api/v1/tasks/:task_id/comments', "Create new task's comment"
      param_group :comment
      def create
        render json: @comment, **(@comment.save(comment_params) ? created : unprocessable_entity)
      end

      api :DELETE, '/v1/comments/:id', "Delete specific task's comment"
      def destroy
        @comment.destroy && head(:no_content)
      end

      private

      def comment_params
        root_params.permit(:text, :image)
      end
    end
  end
end
