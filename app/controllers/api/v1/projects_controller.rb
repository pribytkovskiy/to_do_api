module Api::V1
  class ProjectsController < ApplicationController
    before_action :set_project, only: %i[update destroy]
    before_action :authenticate_api_v1_user!

    def index
      @projects = Project.where(user_id: current_api_v1_user.id)

      render json: @projects
    end

    def create
      @project = Project.new(project_params)
      @project.user_id = current_api_v1_user.id
      if @project.save
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    def update      
         if @project.update(project_params)        
            render json: @project
         else        
            render json: @project.errors, status: :unprocessable_entity      
         end
    end

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