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
end
