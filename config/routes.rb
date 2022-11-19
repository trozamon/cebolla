def reviews(action)
  get action, on: :member, action: "#{action}?"
  post action, on: :member
end

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  resources :customers do
    get :project_status, on: :member
  end

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

  resources :tasks, only: %i[destroy edit index show update] do
    resources :hours, only: %i[create new]

    post :complete, on: :member
    post :resolve, on: :member
    post :start, on: :member
    post :unstart, on: :member
  end

  # TODO: limit this to admins, e.g. authenticate :user, -> (user) { user.admin? } do
  authenticate :user do
    namespace :admin do
      mount PgHero::Engine, at: :pghero
    end
  end
end
