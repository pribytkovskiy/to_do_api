Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index create update destroy]
      resources :tasks, only: %i[index create update destroy]
      mount_devise_token_auth_for 'User', at: 'auth', defaults: { format: "json" },
        controllers: {
          sessions: 'api/v1/devise_token_auth/sessions'
        }
    end
  end
end
