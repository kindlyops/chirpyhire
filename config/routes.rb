require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resource :client_version, only: :show
  resource :health, only: :show
  resources :candidates, only: :index, concerns: :paginatable
  resources :recruiting_ads, only: %i[index update]
  resource :dashboard
  resources :segments
  resources :tags

  resources :contacts, only: [:show] do
    resources :notes, only: %i[index create update destroy]
    resource :star, only: :create
  end

  resources :inboxes, only: %i[index] do
    resources :conversations, only: %i[index show update]
  end

  resources :conversations, only: [] do
    resources :messages, only: %i[index create], controller: 'conversations/messages'
  end

  resources :organizations, only: %i[show update] do
    resources :teams, only: %i[create], controller: 'organizations/teams' do
      resources :members, only: %i[create destroy]
    end
    resources :people, only: %i[update], controller: 'organizations/accounts'

    namespace :settings do
      resource :general
      resources :team_members
      resources :teams
    end

    namespace :billing do
      resource :company
    end

    resource :customer
  end

  resources :bots, controller: 'engage/bots'
  resources :campaigns, controller: 'engage/campaigns'
  
  namespace :engage do
    resources :campaigns
    resources :bots do
      resources :questions, only: %i[update]
    end
  end

  post 'twilio/text', to: 'organizations/subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text' => 'organizations/messages#create'

  resource :current_account, only: :show, controller: 'current_account'
  resource :current_organization, only: :show, controller: 'current_organization'

  devise_for :accounts, controllers: {
    passwords: 'passwords',
    sessions: 'sessions',
    registrations: 'registrations',
    invitations: 'invitations'
  }

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

  get '/caregivers', to: redirect('/candidates', status: 301)
  root to: redirect('/candidates')
end
