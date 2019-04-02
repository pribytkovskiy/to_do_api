module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_request!
      load_and_authorize_resource :project
      load_and_authorize_resource :task, through: :project, shallow: true

      resource_description do
        short "Task's endpoints"
        error 422, 'Unprocessable entity'
        error 401, 'Unauthorized'
        formats %w[json]
      end

      api :GET, '/v1/projects/:project_id/tasks', "Get all project's tasks"
      def index
        render json: @tasks.order(:position), :ok
      end

      api :GET, '/v1/tasks/:id', "Get specific project's task"
      param :id, Fixnum
      def show
        render json: @task, :ok
      end

      api :POST, '/v1/projects/:project_id/tasks', "Create new project's task"
      param :project_id, Fixnum, :name, String, :deadline, :position, :completed
      def create
        render json: @task, @task.save(task_params) ? created : unprocessable_entity
      end

      api :PATCH, '/v1/tasks/:id', 'Update specific task'
      param :id, Fixnum, :name, String, :deadline, :position, :completed
      def update
        render json: @task, @task.update(task_params) ? created : unprocessable_entity
      end

      api :DELETE, '/v1/tasks/:id', "Delete specific project's task"
      param :id, Fixnum
      def destroy
        @task.destroy && head(:no_content)
      end

      private

      def task_params
        params.require(:task).permit(:name, :deadline, :position, :completed)
      end
    end
  end
end
