def reviews(action)
  get action, on: :member, action: "#{action}?"
  post action, on: :member
end

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  resources :customers
  resources :entities

  resources :line_items, only: %i[edit update]
  resources :invoices do
    post 'post', on: :member
    resources :line_items, only: %i[create new]
  end

  resources :projects, except: :destroy do
    reviews :archive
    resources :tasks, only: %i[create new]
  end

  resources :tasks, only: %i[destroy edit show update] do
    resources :hours, only: %i[create new]
  end
end
