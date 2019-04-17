# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_request!
      load_and_authorize_resource

      resource_description do
        short "Project's endpoints"
        error 422, 'Unprocessable entity'
        error 401, 'Unauthorized'
        formats %w[json]
      end

      api :GET, '/projects', "Get all user's projects"
      def index
        render json: @projects, status: :ok
      end

      api :GET, '/v1/projects/:id', "Get specific user's project"
      param :id, :number, desc: 'id of the requested project', required: true
      def show
        render json: @project, status: :ok
      end

      api :POST, '/projects/:id', "Create new user's project"
      param :project, Hash, required: true do
        param :name, String, required: true
      end
      def create
        if @project.save(project_params)
          render json: @project, status: :created
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/projects/:id', "Update specific user's project"
      param :project, Hash, required: true do
        param :id, :number, required: true
        param :name, String, required: true
      end
      def update
        if @project.update(project_params)
          render json: @project, status: :created
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/projects/:id', "Delete specific user's project"
      param :id, :number, desc: 'id of the destroy project', required: true
      def destroy
        if @project.destroy
          head :no_content, status: :ok
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      private

      def project_params  
        params.require(:project).permit(:name)
      end
    end
  end
end
