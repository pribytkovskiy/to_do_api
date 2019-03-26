module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource :project
      load_and_authorize_resource :task, through: :project, shallow: true

      resource_description do
        short "Task's endpoints"
        error 422, 'Unprocessable entity'
        error 401, 'Unauthorized'
        formats %w[json]
      end

      def_param_group :task do
        param :data, Hash, required: true do
          param :attributes, Hash, required: true do
            param :name, String, required: true
            param :deadline, String
            param :position, :number
          end
        end
      end

      api :GET, '/v1/projects/:project_id/tasks', "Get all project's tasks"
      def index
        render json: @tasks.order(:position), **ok
      end

      api :GET, '/v1/tasks/:id', "Get specific project's task"
      def show
        render json: @task, **ok
      end

      api :POST, '/v1/projects/:project_id/tasks', "Create new project's task"
      param_group :task
      def create
        render json: @task, **(@task.save(task_params) ? created : unprocessable_entity)
      end

      api :PATCH, '/v1/tasks/:id', 'Update specific task'
      param_group :task
      def update
        render json: @task, **(@task.update(task_params) ? created : unprocessable_entity)
      end

      api :DELETE, '/v1/tasks/:id', "Delete specific project's task"
      def destroy
        @task.destroy && head(:no_content)
      end

      api :PATCH, '/v1/tasks/:id/complete', "Mark specific project's task as completed / uncompleted"
      def complete
        @task.update completed: !@task.completed?
        render json: @task, **(@task.errors.none? ? created : unprocessable_entity)
      end

      api :PATCH, '/v1/tasks/:id/position', "Change position of the specific project's task"
      param :data, Hash, required: true do
        param :attributes, Hash, required: true do
          param :position, :number, required: true
        end
      end
      def position
        @task.insert_at task_position_params[:position].to_i
        render json: @task, **(@task.errors.none? ? created : unprocessable_entity)
      end

      private

      def task_params
        root_params.permit(:name, :deadline)
      end

      def task_position_params
        root_params.permit(:position)
      end
    end
  end
end
