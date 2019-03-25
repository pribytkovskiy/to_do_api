module Api::V1
  class ProjectsController < ApplicationController
    before_action :set_project, only: %i[update destroy]
    load_and_authorize_resource

    resource_description do
      short "Project's endpoints"
      error 422, 'Unprocessable entity'
      error 401, 'Unauthorized'
      formats %w[json]
    end

    def_param_group :project do
      param :data, Hash, required: true do
        param :attributes, Hash, required: true do
          param :name, String, required: true
        end
      end
    end

    api :GET, '/projects', "Get all user's projects"
    def index
      @projects = Project.where(user_id: current_api_v1_user.id)

      render json: @projects
    end

    api :POST, '/projects/:id'
    param :id, :number
    def create
      @project = Project.new(project_params)
      @project.user_id = current_api_v1_user.id
      if @project.save
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    api :GET, '/users/:id'
    param :id, :number
    def update      
         if @project.update(project_params)        
            render json: @project
         else        
            render json: @project.errors, status: :unprocessable_entity      
         end
    end

    api :GET, '/users/:id'
    param :id, :number
    def destroy
      @project.destroy
      if @project.destroy
        head :no_content, status: :ok
      else
        render json: @project.errors, status: :unprocessable_entity
      end      
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name)
    end
  end
end