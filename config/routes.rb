Rails.application.routes.draw do
  apipie
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index create update destroy]
      resources :tasks, only: %i[index create update destroy]
      mount_devise_token_auth_for 'User', at: 'auth', defaults: { format: "json" }
    end
  end
end
