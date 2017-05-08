require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resource :health, only: :show

  resources :messages, only: [:index, :show], param: :contact_id do
    resources :notes, only: [:index, :create, :update, :destroy]
  end

  resources :caregivers, only: :index, concerns: :paginatable
  resource :candidate, only: [:show, :update], controller: 'ideal_candidates'
  resource :recruiting_ad, only: [:show, :update, :create]
  resources :ideal_candidate_suggestions, only: :create
  post '/candidacies', to: 'candidacies#index', defaults: { format: 'csv' }

  resources :contacts, only: [] do
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

  post 'twilio/text', to: 'brokers/subscriptions#create', constraints: Constraint::Broker::OptIn.new
  post 'twilio/text', to: 'organizations/subscriptions#create', constraints: Constraint::OptIn.new

  post 'twilio/text', to: 'brokers/subscriptions#destroy', constraints: Constraint::Broker::OptOut.new
  post 'twilio/text', to: 'organizations/subscriptions#destroy', constraints: Constraint::OptOut.new

  post 'twilio/text', to: 'brokers/answers#create', constraints: Constraint::Broker::Answer.new
  post 'twilio/text', to: 'organizations/answers#create', constraints: Constraint::Answer.new

  post 'twilio/text' => 'brokers/base#create', constraints: Constraint::Broker.new
  post 'twilio/text' => 'organizations/base#create'

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
