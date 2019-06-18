RailsAdmin.config do |config|
  require Rails.root.join('lib', 'rails_admin', 'config', 'actions', 'impersonate.rb')
  config.parent_controller = 'RailsAdmin::ParentController'
  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    impersonate
  end

  config.model 'Subscription' do
    list do
      field :id
      field :internal_status
      field :internal_canceled_at
      field :trial_ends_at
    end

    show do
      include_all_fields
    end

    edit do
      field :id
      field :internal_status
      field :internal_canceled_at
      field :trial_ends_at
    end

  end

  config.default_items_per_page = 100
end
