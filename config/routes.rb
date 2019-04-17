Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :projects, shallow: true do
        resources :tasks do
          resources :comments, only: %i[index create destroy]
        end
      end
      namespace :auth do
        resources :users, param: :_email
        post '/login', to: 'authentication#create'
      end
    end
  end
end
