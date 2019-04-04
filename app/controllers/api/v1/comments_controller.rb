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

      api :GET, '/v1/tasks/:task_id/comments', "Get all task's comments"
      def index
        render json: @comments, status: :ok
      end

      api :POST, '/api/v1/tasks/:task_id/comments', "Create new task's comment"
      param :text, String, required: true
      param :image, File
      def create
        if @comment.save(comment_params)
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/comments/:id', "Update specific user's comment"
      param :id, :number, desc: 'id of the update comment'
      param :name, String
      def update
        if @comment.update(comment_params)
          render :show, status: :ok
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/v1/comments/:id', "Delete specific task's comment"
      param :id, :number, desc: 'id of the destroy comment'
      def destroy
        if @comment.destroy
          head :no_content, status: :ok
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:text, :image)
      end
    end
  end
end
