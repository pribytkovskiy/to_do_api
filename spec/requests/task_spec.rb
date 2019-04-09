RSpec.describe 'Tasks requests', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:task_completed_true) { create(:task_completed_true, project: project) }
  let(:token) { JsonWebToken.encode({ user_id: user.id }) }
  let(:auth_headers) { { Authorization: token, accept: 'application/json' } }

  let(:valid_params) { { task: attributes_for(:task) } }
  let(:invalid_params) { { task: { name: '' } } }
  let(:valid_update_params) { { task: attributes_for(:task) } }
  let(:valid_update_params_false) { { task: { completed: 'false' } } }
  let(:up_position_params) { { task: { position: Api::V1::TasksController::COMMANDS_POSITION[:up] } } }

  describe 'GET /tasks/:id' do
    context 'logged in user' do
      it 'returns all tasks in expected format with status ok', :show_in_doc do
        2.times { create(:task, project: project) }
        get api_v1_project_tasks_path(project), headers: auth_headers
        expect(response).to have_http_status(200)
        expect(response).to match_json_schema('task')
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
        expect(response).to match_json_schema('task')
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
          expect(response).to match_json_schema('task')
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
        it 'updates task record name' do
          name_before = task.name
          name_after = valid_update_params[:name]
          expect { patch api_v1_task_path(task), params: valid_update_params, headers: auth_headers }.to(
            change { project.tasks.first.name }.from(name_before).to(name_after)
          )
        end

        it 'updates task record completed' do
          task_completed_true
          expect { patch api_v1_task_path(task_completed_true), params: valid_update_params_false, headers: auth_headers }.to(
            change { project.tasks.first.completed }.from(true).to(false)
          )
        end

        it 'updates position of the task record' do
          task
          after_position = project.tasks.first.position
          expect { patch patch api_v1_task_path(task), params: up_position_params, headers: auth_headers }.to(
            change { project.tasks.first.position }.from(after_position).to(after_position - 1)
          )
        end

        it 'returns updated task data with status ok', :show_in_doc do
          patch api_v1_task_path(task), params: valid_update_params, headers: auth_headers
          expect(response).to have_http_status :created
          expect(response).to match_json_schema('task')
        end
      end

      context 'with invalid params' do
        it 'does nothing with db' do
          patch api_v1_task_path(task), params: valid_update_params, headers: auth_headers
          expect project.tasks.first.name = valid_params[:name]
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
end
