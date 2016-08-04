require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  resource :health, only: :show

  resources :candidates, only: [:index, :update, :show]
  resources :conversations, only: :index

  resources :users, only: [] do
    resources :messages, only: [:index, :create], shallow: true
  end

  resources :dogs

  resource :survey, only: :show

  resources :address_questions, only: [:show, :edit, :update]
  resources :document_questions, only: [:show, :edit, :update]
  resources :choice_questions, only: [:show, :edit, :update]
  resources :questions, only: :edit

  namespace :maps do
    resources :candidates, only: [:index, :show]
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
      resources :actionables
      resources :answers
      resources :candidates
      resources :candidate_features
      resources :surveys
      resources :categories
      resources :inquiries
      resources :locations
      resources :media_instances
      resources :messages
      resources :notifications
      resources :organizations
      resources :questions
      resources :referrals
      resources :referrers
      resources :rules
      resources :templates
      resources :users

      root to: "accounts#index"
    end
  end

  root 'candidates#index'
end
