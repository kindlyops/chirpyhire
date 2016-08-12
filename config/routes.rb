require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  resource :health, only: :show

  resources :candidates, only: [:index, :update, :show]
  get "messages" => "conversations#index"

  resources :users, only: [] do
    resources :messages, only: [:index, :create], shallow: true
  end

  resource :survey, only: [:show, :edit, :update]

  resources :yes_no_questions, except: :destroy
  resources :address_questions, except: :destroy
  resources :document_questions, except: :destroy
  resources :choice_questions, except: :destroy
  resources :questions, only: [:edit, :new]
  resources :templates, only: [:edit, :update]

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
      resources :template_actionables
      resources :survey_actionables
      resources :address_questions
      resources :document_questions
      resources :choice_questions
      resources :yes_no_questions
      resources :answers
      resources :candidates
      resources :candidate_features
      resources :surveys
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
