require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  resource :health, only: :show

  resource :scenes, only: :show
  resources :candidates, only: [:index, :update]
  resources :conversations, only: :index

  resources :users, only: [] do
    resources :messages, only: [:index, :new, :create], shallow: true
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
