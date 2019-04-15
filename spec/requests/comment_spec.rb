RSpec.describe 'Comments requests', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment) { create(:comment, task: task) }
  let(:token) { JsonWebToken.encode({ user_id: user.id }) }
  let(:auth_headers) { { Authorization: token, accept: 'application/json' } }

  let(:valid_params) { { comment: { text: FFaker::Name.name } } }
  let(:invalid_params) { { comment: { text: '' } } }


  describe 'GET /api/v1/tasks/:task_id/comments' do
    context 'logged in user' do
      it "returns all task's comments with status ok", :show_in_doc do
        comment
        get api_v1_task_comments_path(task), headers: auth_headers
        expect(response).to match_response_schema('comment')
        expect(response).to have_http_status(200)
      end
    end

    context 'not logged in user' do
      it 'restricts access', :show_in_doc do
        get api_v1_task_comments_path(task)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/tasks/:task_id/comments' do
    context 'logged in user' do
      context 'with valid params' do
        it 'creates new task record in db and returns status created', :show_in_doc do
          expect { post api_v1_task_comments_path(task), params: valid_params, headers: auth_headers }.to(
            change { Comment.count }.from(0).to(1)
          )
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid params' do
        it "doesn't create any records in db" do
          post api_v1_task_comments_path(task), params: invalid_params, headers: auth_headers
          expect(Comment.count).to eq(0)
        end
      end
    end

    context 'not logged in user' do
      it 'restricts access', :show_in_doc do
        post api_v1_task_comments_path(task), params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    context 'logged in user' do
      it 'removes comment record from db and returns status no content', :show_in_doc do
        comment
        expect { delete api_v1_comment_path(comment), headers: auth_headers }.to change { Comment.count }.from(1).to(0)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'not logged in user' do
      it 'restricts access', :show_in_doc do
        delete api_v1_comment_path(comment)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
