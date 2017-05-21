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
  resources :recruiting_ads, only: [:index, :update]
  resources :ideal_candidate_suggestions, only: :create
  post '/candidacies', to: 'candidacies#index', defaults: { format: 'csv' }

  resources :contacts, only: [] do
    resource :star, only: :create
    resources :messages, only: :create
  end

  resources :organizations, only: [:show, :update] do
    resources :teams, except: :destroy, controller: 'organizations/teams' do
      resources :members, only: [:create, :destroy, :index, :update, :new]
    end
    resources :people, only: [:index, :show, :update], controller: 'organizations/accounts'
  end

  post 'twilio/text', to: 'teams/subscriptions#create', constraints: Constraint::OptIn.new
  post 'twilio/text', to: 'teams/subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text', to: 'teams/answers#create', constraints: Constraint::Answer.new
  post 'twilio/text' => 'teams/messages#create'

  devise_for :accounts, controllers: { passwords: 'passwords', sessions: 'sessions', registrations: 'registrations', invitations: 'invitations' }

  resources :accounts, only: [:show, :update] do
    post :stop_impersonating, on: :collection

    namespace :settings do
      resource :password, only: [:show, :update]
    end
  end

  authenticate :account, ->(a) { a.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  root 'caregivers#index'
end
