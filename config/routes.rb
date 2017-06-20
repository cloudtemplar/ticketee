Rails.application.routes.draw do
  namespace :admin do
    root 'application#index'
    resources :projects, only: [:new, :create, :destroy]
    resources :users
  end

  resources :projects, except: [:new, :create, :destroy] do
    resources :tickets
  end

  devise_for :users

  root 'projects#index'
end
