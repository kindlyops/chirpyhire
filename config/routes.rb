Rails.application.routes.draw do

  post 'twilio/text', to: 'referrals#create', constraints: VcardConstraint.new
  post 'twilio/text', to: 'subscriptions#create', constraints: OptInConstraint.new
  post 'twilio/text', to: 'subscriptions#destroy', constraints: OptOutConstraint.new
  post 'twilio/text' => 'sms#text'

  devise_for :accounts

  devise_scope :account do
    root :to => 'devise/sessions#new'
  end
end
