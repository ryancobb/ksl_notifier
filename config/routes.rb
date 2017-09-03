require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :users
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :user do
    authenticated :user do
      root 'items#index'
      mount Sidekiq::Web => '/sidekiq' # TODO: Move this to admin route
      
      resources :items do
        get :refresh, :on => :member
      end
    end

    unauthenticated do
      root 'devise/sessions#new'
    end
  end

end
