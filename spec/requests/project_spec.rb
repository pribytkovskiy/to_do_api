RSpec.describe 'Projects requests', type: :request do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let(:token) { JsonWebToken.encode({ user_id: user.id }) }
  let(:auth_headers) { { Authorization: token, accept: 'application/json' } }

  let(:valid_params) { { project: { name: FFaker::Name.name } } }
  let(:invalid_params) { { project: { name: '' } } }
  let(:valid_update_params) { { project: { name: FFaker::Name.name } } }

  describe 'GET /api/v1/projects' do
    context 'logged in user' do
      it 'returns all projects in expected format with status 200', :show_in_doc do
        get api_v1_projects_path, headers: auth_headers
        expect(response).to have_http_status(200)
        expect(response).to match_response_schema('projects/index')
      end
    end

    context 'not logged in user' do
      it 'restricts access', :show_in_doc do
        get api_v1_projects_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/projects' do
    context 'logged in user' do
      context 'with valid params' do
        it 'creates project and returns projects data, corresponding to shema with status created', :show_in_doc do
          post api_v1_projects_path, params: valid_params, headers: auth_headers
          expect(response).to have_http_status(:created)
          expect(response).to match_response_schema('projects/project')
        end

        it 'creates new project record in db' do
          expect { post api_v1_projects_path, params: valid_params, headers: auth_headers }.to(
            change { Project.count }.from(0).to(1)
          )
        end
      end

      context 'with invalid params' do
        it 'returns errors object with status unprocessable entity', :show_in_doc do
          post api_v1_projects_path, params: invalid_params, headers: auth_headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does nothing with db' do
          post api_v1_projects_path, params: invalid_params, headers: auth_headers
          expect(Project.count).to eq(0)
        end
      end
    end

    context 'not logged in user', :show_in_doc do
      it 'restricts access' do
        post api_v1_projects_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/projects/:id' do
    context 'logged in user' do
      it 'creates project and returns projects data, corresponding to shema with status created', :show_in_doc do
        get api_v1_project_path(project), headers: auth_headers
        expect(response).to have_http_status(200)
        expect(response).to match_response_schema('projects/project')
      end
    end
    context 'not logged in user' do
      it 'restricts access with status unauthorized', :show_in_doc do
        get api_v1_project_path(project)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/projects/:id' do
    context 'logged in user' do
      context 'with valid params' do
        it 'updates project record' do
          name_before = project.name
          name_after = valid_update_params[:name]
          expect { patch api_v1_project_path(project), params: valid_update_params, headers: auth_headers}.to(
            change { user.projects.first.name }.from(name_before).to(name_after)
          )
        end

        it 'returns project with updated data with status ok', :show_in_doc do
          patch api_v1_project_path(project), params: valid_update_params, headers: auth_headers
          expect(response).to have_http_status(:created)
          expect(response).to match_response_schema('projects/project')
        end
      end

      context 'with invalid params' do
        it 'does nothing with db' do
          patch api_v1_project_path(project), params: valid_update_params, headers: auth_headers
          expect user.projects.first.name = valid_params[:name]
        end

        it 'returns errors object with status unprocessable entity', :show_in_doc do
          patch api_v1_project_path(project), params: invalid_params, headers: auth_headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
    context 'not logged in user' do
      it 'restricts access with status unauthorized', :show_in_doc do
        patch api_v1_project_path(project), params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    context 'logged in user' do
      it 'deletes project record from db', :show_in_doc do
        project
        expect { delete api_v1_project_path(project), headers: auth_headers }.to(
          change { Project.count }.from(1).to(0)
        )
      end

      it 'returns nothing', :show_in_doc do
        delete api_v1_project_path(project), headers: auth_headers
        expect(response).to have_http_status(:no_content)
      end
    end
    context 'not logged in user' do
      it 'restricts access with status unauthorized', :show_in_doc do
        delete api_v1_project_path(project)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'not deletes project record from db' do
        delete api_v1_project_path(project)
        expect(Project.count).to eq(1)
      end
    end
  end
end
