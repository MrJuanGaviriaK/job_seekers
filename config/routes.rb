Rails.application.routes.draw do
  require 'sidekiq/web'

  namespace :api do
    namespace :v1 do
      resources :opportunities, only: [:index, :create] do
        post :apply, on: :member
      end
    end
  end

  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
