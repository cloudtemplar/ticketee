require 'heartbeat/application'

Rails.application.routes.draw do
  mount Heartbeat::Application, at: "/heartbeat"

  namespace :admin do
    root 'application#index'
    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      patch :archive, on: :member
    end
    resources :states, only: [:index, :new, :create] do
      member do
        patch :make_default
      end
    end
  end

  namespace :api do
    namespace :v2 do
      mount API::V2::Tickets, at: "/projects/:project_id/tickets"
    end

    scope path: "/projects/:project_id", as: "project" do
      resources :tickets
    end
  end

  resources :attachments, only: [:show]

  resources :projects, except: [:new, :create, :destroy] do
    resources :tickets do
      collection do
        get :search
      end

      member do
        post :watch
      end
    end
  end

  resources :tickets, only: [] do
    resources :comments, only: [:create]
    resources :tags, only: [] do
      member do
        delete :remove  
      end
    end
  end

  devise_for :users

  root 'projects#index'
end
