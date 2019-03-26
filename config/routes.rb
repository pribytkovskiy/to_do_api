Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index create update destroy]
      resources :tasks, only: %i[index create update destroy]
      namespace :auth do
        resources :users, param: :_email
        post '/login', to: 'authentication#create'
      end
    end
  end
end
