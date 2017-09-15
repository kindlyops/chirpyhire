require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resource :getting_started, only: :show, controller: 'getting_started'
  resource :health, only: :show
  resources :candidates, only: %i[index new create], concerns: :paginatable do
    collection do
      post 'search(/page/:page)' => 'candidates#search', as: :search
    end
  end

  namespace :candidates do
    resources :segments, only: :show
  end

  resources :recruiting_ads, only: %i[index update]
  resource :dashboard
  resources :segments
  resources :tags
  resources :contact_stages

  resources :contacts, only: %i[show update] do
    resources :notes, only: %i[index create update destroy]
  end

  resources :inboxes, only: %i[index] do
    resources :conversations, only: %i[index show update]
    resource :conversations_count, only: %i[show]
  end

  resources :conversations, only: [] do
    resources :parts, only: %i[index create], controller: 'conversations/parts'
  end

  namespace :import do
    resources :csv do
      resources :mappings
      resources :tags
      resource :summary
    end
  end

  resources :organizations, only: %i[show update] do
    resources :teams, only: %i[create], controller: 'organizations/teams' do
      resources :members, only: %i[create destroy]
    end
    resources :people, only: %i[update], controller: 'organizations/accounts'

    namespace :settings do
      resource :general
      resources :team_members
      resources :teams
      resources :phone_numbers
      namespace :candidate do
        resources :stages do
          collection do
            post :reorder
          end
        end
      end
      resource :forwarding_phone_number
    end

    namespace :billing do
      resource :company
      resource :summary
      resources :invoices
    end

    resource :customer
  end

  namespace :engage do
    namespace :manual do
      resources :campaigns, controller: 'messages'
    end

    namespace :auto do
      resources :campaigns
      resources :bots do
        resources :goals do
          resource :remove, controller: 'goals/removes'
        end

        resources :questions do
          resource :remove, controller: 'questions/removes'
          resources :follow_ups
        end

        post :clone
      end
    end

    namespace :manual do
      resources :messages
    end
  end

  resources :bots, only: %i[index show] do
    resources :questions, only: %i[update]
  end

  resource :current_account, only: :show, controller: 'current_account'
  resource :current_organization, only: :show, controller: 'current_organization'

  devise_for :accounts, controllers: {
    passwords: 'passwords',
    sessions: 'sessions',
    registrations: 'registrations',
    invitations: 'invitations'
  }

  resources :accounts, only: %i[show update] do
    post :stop_impersonating, on: :collection

    resource :notifications, controller: 'accounts/notifications'

    namespace :settings do
      resource :password, only: %i[show update]
    end
  end

  authenticate :account, ->(a) { a.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  post 'twilio/text', to: 'organizations/subscriptions#destroy', constraints: Constraint::OptOut.new
  post 'twilio/text' => 'organizations/messages#create'
  post 'twilio/voice', defaults: { format: 'xml' }

  get '/caregivers', to: redirect('/candidates/segments/all', status: 301)
  root to: redirect('/candidates/segments/all')
end
