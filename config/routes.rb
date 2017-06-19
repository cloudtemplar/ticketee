Rails.application.routes.draw do
  namespace :admin do
    root 'application#index'
  end

  resources :projects do
    resources :tickets
  end

  devise_for :users

  root 'projects#index'
end
