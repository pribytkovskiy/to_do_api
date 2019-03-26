# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_api_v1_user!
      load_and_authorize_resource

      resource_description do
        short "Project's endpoints"
        error 422, 'Unprocessable entity'
        error 401, 'Unauthorized'
        formats %w[json]
      end

      api :GET, '/projects', "Get all user's projects"
      def index
        @projects = Project.where(user_id: current_api_v1_user.id)

        render json: @projects
      end

      api :GET, '/v1/projects/:id', "Get specific user's project"
      param :id, :number
      def show
        set_project

        render json: @project
      end

      api :POST, '/projects/:id', "Create new user's project"
      param :name, String, required: true
      def create
        @project = Project.new(project_params)
        @project.user_id = current_api_v1_user.id
        if @project.save
          render json: @project, status: :created
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/projects/:id', "Update specific user's project"
      param :id, :number
      def update
        set_project
        if @project.update(project_params)
          render json: @project
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/projects/:id', "Delete specific user's project"
      param :id, :number
      def destroy
        set_project
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
end
