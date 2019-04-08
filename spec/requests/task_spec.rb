RSpec.describe 'Tasks requests', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:token) { JsonWebToken.encode({ user_id: user.id }) }
  let(:auth_headers) { { Authorization: token, accept: 'application/json' } }

  let(:valid_params) { { task: attributes_for(:task) } }
  let(:invalid_params) { { task: { name: '' } } }
  let(:valid_update_params) { { task: attributes_for(:task) } }
  let(:invalid_position_params) { { task: { position: 'invalid' } } }
  let(:valid_position_params) { { task: { position: 7 } } }

  describe 'GET /tasks/:id' do
    context 'logged in user' do
      it 'returns all tasks in expected format with status ok', :show_in_doc do
        2.times { create(:task, project: project) }
        get api_v1_project_tasks_path(project), headers: auth_headers
        expect(response).to have_http_status(200)
        expect(response).to match_response_schema('tasks/index')
      end
    end

    context 'not logged in user' do
      it 'returns http not authorized', :show_in_doc do
        get api_v1_project_tasks_path(project)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    context 'logged in user' do
      it 'returns task data, corresponding to shema with status created', :show_in_doc do
        get api_v1_task_path(task), headers: auth_headers
        expect(response).to have_http_status(200)
        expect(response).to match_response_schema('tasks/task')
      end
    end
    context 'not logged in user' do
      it 'returns http not authorized', :show_in_doc do
        get api_v1_task_path(task)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks' do
    context 'logged in user' do
      context 'with valid params' do
        it 'creates new task, returns tasks data, corresponding to shema with status created', :show_in_doc do
          post api_v1_project_tasks_path(project), params: valid_params, headers: auth_headers
          expect(response).to have_http_status :created
          expect(response).to match_response_schema('tasks/task')
        end

        it 'creates new task record in db' do
          expect { post api_v1_project_tasks_path(project), params: valid_params, headers: auth_headers }.to(
            change { Task.count }.from(0).to(1)
          )
        end
      end

      context 'with invalid params' do
        it 'returns errors object with status unprocessable entity', :show_in_doc do
          post api_v1_project_tasks_path(project), params: invalid_params, headers: auth_headers
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does nothing with db' do
          post api_v1_project_tasks_path(project), params: invalid_params, headers: auth_headers
          expect(Task.count).to eq 0
        end
      end
    end

    context 'not logged in user' do
      it 'returns http not authorized', :show_in_doc do
        post api_v1_project_tasks_path(project)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/tasks/:id' do
    context 'logged in user' do
      context 'with valid params' do
        it 'updates task record' do
          name_before = task.name
          name_after = valid_update_params[:data][:attributes][:name]
          expect { patch api_v1_task_path(task), params: valid_update_params, headers: auth_headers }.to(
            change { project.tasks.first.name }.from(name_before).to(name_after)
          )
        end

        it 'returns updated task data with status ok', :show_in_doc do
          patch api_v1_task_path(task), params: valid_update_params, headers: auth_headers
          expect(response).to have_http_status :created
          expect(response).to match_response_schema('tasks/task')
        end
      end

      context 'with invalid params' do
        it 'does nothing with db' do
          patch api_v1_task_path(task), params: valid_update_params, headers: auth_headers
          expect project.tasks.first.name = valid_params[:data][:attributes][:name]
        end

        it 'returns errors object with status unprocessable entity', :show_in_doc do
          patch api_v1_task_path(task), params: invalid_params, headers: auth_headers
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
    context 'not logged in user' do
      it 'returns http not authorized', :show_in_doc do
        patch api_v1_task_path(task), params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    context 'logged in user' do
      it 'deletes task record from db' do
        task
        expect { delete api_v1_task_path(task), headers: auth_headers }.to change { Task.count }.from(1).to(0)
      end

      it 'returns nothing', :show_in_doc do
        delete api_v1_task_path(task), headers: auth_headers
        expect(response).to have_http_status :no_content
      end
    end
    context 'not logged in user' do
      it 'returns http not authorized', :show_in_doc do
        delete api_v1_task_path(task)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'not deletes task record from db' do
        delete api_v1_task_path(task)
        expect(Task.count).to eq(1)
      end
    end
  end

  describe 'PATCH /api/v1/tasks/:id/complete' do
    context 'logged in user' do
      it 'changes task record property, named "completed" to true' do
        task
        expect { patch complete_api_v1_task_path(task), headers: auth_headers }.to(
          change { project.tasks.first.completed }.from(false).to(true)
        )
      end

      it 'returns updated task data with status ok', :show_in_doc do
        patch complete_api_v1_task_path(task), headers: auth_headers
        expect(response).to have_http_status :created
        expect(response).to match_response_schema('tasks/task')
      end
    end
    context 'not logged in user' do
      it 'returns http not authorized', :show_in_doc do
        patch complete_api_v1_task_path(task)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/tasks/:id/position' do
    context 'logged in user' do
      it 'updates position of the task record' do
        task
        expect { patch position_api_v1_task_path(task), params: valid_position_params, headers: auth_headers }.to(
          change { project.tasks.first.position }.from(1).to(7)
        )
      end

      it 'returns updated task data with status ok', :show_in_doc do
        patch position_api_v1_task_path(task), params: valid_position_params, headers: auth_headers
        expect(response).to have_http_status :created
        expect(response).to match_response_schema('tasks/task')
      end
    end
    context 'not logged in user' do
      it 'returns http not authorized', :show_in_doc do
        patch position_api_v1_task_path(task), params: valid_position_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
