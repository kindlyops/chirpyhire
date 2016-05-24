require 'sidekiq/web'

Rails.application.routes.draw do

  resources :templates, only: :index
  resources :candidates, only: [:index, :show]
  resources :referrers, only: :index
  resources :automations, only: :show do
    resources :rules, except: [:index, :destroy], shallow: true
  end

  resources :users, only: [] do
    resources :messages, only: [:new, :create], shallow: true
  end

  post 'twilio/text', to: 'referrals#create', constraints: Constraint::Vcard.new
  post 'twilio/text', to: 'subscriptions#create', constraints: Constraint::OptIn.new
  post 'twilio/text', to: 'subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text', to: 'answers#create', constraints: Constraint::Answer.new
  post 'twilio/text' => 'sms#invalid_message'

  devise_for :accounts, controllers: {registrations: 'registrations', invitations: 'invitations'}

  authenticate :account, lambda { |a| a.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'candidates#index'
end
