require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  resource :health, only: :show
  resource :dashboard, only: :show
  resource :candidate, only: [:show, :update], controller: 'ideal_candidates'
  resources :ideal_candidate_suggestions, only: :create
  resources :candidacies, only: :index
  post 'candidacies.csv', to: 'candidacies#index'

  resources :contacts, only: :index do
    resource :conversation, only: :show
    resources :messages, only: :create
  end

  resources :subscriptions

  post 'twilio/text', to: 'organizations/subscriptions#create', constraints: Constraint::OptIn.new
  post 'twilio/text', to: 'organizations/subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text', to: 'organizations/answers#create', constraints: Constraint::Answer.new
  post 'twilio/text' => 'organizations/messages#create'

  mount StripeEvent::Engine, at: '/stripe/events'

  devise_for :accounts, controllers: { sessions: 'sessions', registrations: 'registrations', invitations: 'invitations' }
  resources :accounts, only: [] do
    post :stop_impersonating, on: :collection
  end

  authenticate :account, ->(a) { a.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  root 'dashboards#show'
end
