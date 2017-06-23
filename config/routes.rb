Rails.application.routes.draw do
  namespace :admin do
    root 'application#index'
    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      patch :archive, on: :member
    end
  end

  resources :attachments, only: [:show]

  resources :projects, except: [:new, :create, :destroy] do
    resources :tickets
  end

  resources :tickets, only: [] do
    resources :comments, only: [:create]
  end

  devise_for :users

  root 'projects#index'
end
