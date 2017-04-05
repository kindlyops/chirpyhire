require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  resource :health, only: :show
  get '/candidates', to: 'candidates#index'
  resources :caregivers, only: :index
  resource :candidate, only: [:show, :update], controller: 'ideal_candidates'
  resource :recruiting_ad, only: [:show, :update, :create]
  resources :ideal_candidate_suggestions, only: :create
  post '/candidacies', to: 'candidacies#index', defaults: { format: 'csv' }

  resources :contacts, only: [:index, :update] do
    resource :conversation, only: :show
    resources :messages, only: :create
  end

  namespace :settings do
    resource :profile, only: [:show, :update]
    resource :password, only: [:show, :update]
  end

  namespace :organizations do
    namespace :settings do
      resources :people, only: [:index]
      resource :profile, only: [:show, :update]
      resource :billing, only: [:show]
    end
  end

  post 'twilio/text', to: 'organizations/subscriptions#create', constraints: Constraint::OptIn.new
  post 'twilio/text', to: 'organizations/subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text', to: 'organizations/answers#create', constraints: Constraint::Answer.new
  post 'twilio/text' => 'organizations/messages#create'

  devise_for :accounts, controllers: { sessions: 'sessions', registrations: 'registrations', invitations: 'invitations' }
  devise_scope :accounts do
    get 'organizations/settings/people/invitation/new', to: 'invitations#new'
  end
  resources :accounts, only: [] do
    post :stop_impersonating, on: :collection
  end

  authenticate :account, ->(a) { a.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  root 'caregivers#index'
end
