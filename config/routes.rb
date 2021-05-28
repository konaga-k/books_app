# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "books#index"

  devise_for :users, skip: :all # authenticate_user! のために残す

  # 不要なアクションを塞ぐために個別に指定
  devise_scope :user do
    get "users/sign_in" => "users/sessions#new", as: :new_user_session
    post "users/sign_in" => "users/sessions#create", as: :user_session
    delete "users/sign_out" => "users/sessions#destroy", as: :destroy_user_session
    get "users/sign_up" => "users/registrations#new", as: :new_user_registration
    post "users" => "users/registrations#create"
    get "users/edit" => "users/registrations#edit", as: :edit_user_registration
    patch "users" => "users/registrations#update"
    put "users" => "users/registrations#update", as: :user_registration
    match "users/auth/github" => "users/omniauth_authorizes#github", as: :user_github_omniauth_authorize, via: [:get, :post]
    match "users/auth/github/callback" => "users/omniauth_callbacks#github", as: :user_github_omniauth_callback, via: [:get, :post]
  end

  resources :users, only: %i[index show] do
    resources :follows, only: %i[create destroy], controller: "users/follows"
    resources :followings, only: %i[index], controller: "users/followings"
  end

  resources :books do
    resources :comments, only: %i[edit create update destroy], controller: "books/comments"
  end

  resources :reports do
    resources :comments, only: %i[edit create update destroy], controller: "reports/comments"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
