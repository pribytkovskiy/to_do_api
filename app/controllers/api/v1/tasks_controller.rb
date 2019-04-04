module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_request!
      load_and_authorize_resource :project
      load_and_authorize_resource :task, through: :project, shallow: true

      COMMANDS_POSITION = { up: 'up', down: 'down' }

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
      param :id, :number, desc: 'id of the requested task'
      def show
        render json: @task, :ok
      end

      api :POST, '/v1/projects/:project_id/tasks', "Create new project's task"
      param :project_id, :number, desc: 'project_id of the create task'
      param :name, String, required: true, desc: 'name task'
      param :deadline, String, desc: 'deadline task'
      def create
        if @task.save(task_params)
          render json: @task, status: :created
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/v1/tasks/:id', 'Update specific task'
      param :id, :number, desc: 'id of the update task'
      param :name, String, required: true
      param :deadline, String
      param :position, String
      param :completed, Boolean
      def update
        move if task_params[:move]
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/v1/tasks/:id', "Delete specific project's task"
      param :id, :number, desc: 'id of the destroy task'
      def destroy
        if @task.destroy
          head :no_content, status: :ok
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      private

      def move
        case task_params[:position]
        when COMMANDS_POSITION[:up] then @task.move_higher
        when COMMANDS_POSITION[:down] then @task.move_lower
        end
      end

      def task_params
        params.require(:task).permit(:name, :deadline, :position, :completed)
      end
    end
  end
end
