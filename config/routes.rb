require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  resource :health, only: :show

  resources :templates, only: :index do
    get 'preview'
  end

  resource :scenes, only: :show

  resources :users, only: :show
  resources :candidates, only: [:index, :update]
  resources :conversations, only: :index
  resources :referrers, only: :index
  resource :inbox, only: :show
  resources :rules, except: [:destroy], shallow: true


  resources :users, only: [] do
    resources :activities, only: [:index, :update, :show], shallow: true
    resources :messages, only: [:new, :create], shallow: true
  end

  post 'twilio/text', to: 'referrals#create', constraints: Constraint::Vcard.new
  post 'twilio/text', to: 'subscriptions#create', constraints: Constraint::OptIn.new
  post 'twilio/text', to: 'subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text', to: 'answers#create', constraints: Constraint::Answer.new
  post 'twilio/text' => 'sms#unknown_message'

  devise_for :accounts, controllers: {registrations: 'registrations', invitations: 'invitations'}

  authenticate :account, lambda { |a| a.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    namespace :admin do
      resources :accounts
      resources :candidates
      resources :candidate_personas
      resources :messages
      resources :organizations
      resources :referrers
      resources :rules
      resources :templates
      resources :users
      resources :candidate_features
      resources :answers
      resources :chirps
      resources :inquiries
      resources :media_instances
      resources :notifications
      resources :persona_features
      resources :referrals
      resources :addresses
      resources :choices
      resources :documents
      resources :activities

      root to: "accounts#index"
    end
  end

  root 'candidates#index'
end
