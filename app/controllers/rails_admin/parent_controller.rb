class RailsAdmin::ParentController < ActionController::Base
  extend Pretender
  impersonates :account
end
