require 'sidekiq/web'

Rails.application.routes.draw do

  resources :templates, only: :index do
    get 'preview'
  end

  resources :users, only: :show
  resources :candidates, only: [:index, :update]
  resources :referrers, only: :index
  resources :tasks, only: :update
  resource :inbox, only: :show
  resources :rules, except: [:destroy], shallow: true

  resources :users, only: [] do
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
  end

  root 'candidates#index'
end
