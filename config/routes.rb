require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resource :health, only: :show
  resources :caregivers, only: :index, concerns: :paginatable
  resource :candidate, only: %i[show update], controller: 'ideal_candidates'
  resources :recruiting_ads, only: %i[index update]
  resources :ideal_candidate_suggestions, only: :create
  post '/candidacies', to: 'candidacies#index', defaults: { format: 'csv' }
  resource :dashboard

  resources :messages, only: %i[index show], param: :contact_id
  resources :contacts, only: [:show] do
    resources :notes, only: %i[index create update destroy]
    resource :star, only: :create
    resources :messages, only: :create
  end

  resources :inboxes, only: [:show] do
    resources :conversations, only: %i[index show]
    resources :inbox_conversations, only: :index
  end

  resources :conversations, only: [] do
    resources :messages, only: [:index], controller: 'conversations/messages'
  end

  resources :organizations, only: %i[show update] do
    resources :teams, except: :destroy, controller: 'organizations/teams' do
      resources :members, only: %i[create destroy index update new]
    end
    resources :people, only: %i[index show update], controller: 'organizations/accounts'
  end

  post 'twilio/text', to: 'teams/subscriptions#create', constraints: Constraint::OptIn.new
  post 'twilio/text', to: 'teams/subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text', to: 'teams/answers#create', constraints: Constraint::Answer.new
  post 'twilio/text' => 'teams/messages#create'

  devise_for :accounts, controllers: { passwords: 'passwords', sessions: 'sessions', registrations: 'registrations', invitations: 'invitations' }

  resources :accounts, only: %i[show update] do
    post :stop_impersonating, on: :collection

    namespace :settings do
      resource :password, only: %i[show update]
    end
  end

  authenticate :account, ->(a) { a.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  root to: redirect('/caregivers')
end
