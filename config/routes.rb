require 'sidekiq/web'

Rails.application.routes.draw do

  resources :searches, only: [:new, :create, :index, :show]
  resources :leads, only: [:index]
  resources :referrers, only: [:index]


  post 'twilio/text', to: 'referrals#create', constraints: Constraint::Vcard.new
  post 'twilio/text', to: 'subscriptions#create', constraints: Constraint::OptIn.new
  post 'twilio/text', to: 'subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text', to: 'answers#create', constraints: Constraint::Answer.new
  post 'twilio/text' => 'sms#error_message'

  devise_for :accounts, controllers: {registrations: 'registrations'}

  authenticate :account, lambda { |a| a.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'searches#new'
end
