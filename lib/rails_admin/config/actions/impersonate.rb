require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Impersonate < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          authorized? && bindings[:object].class == Account
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-eye-open'
        end

        register_instance_option :pjax? do
          false
        end

        register_instance_option :controller do
          proc do
            real_account = warden.user(:account)

            if real_account == @object
              alert = 'You are already impersonating this user.'
              redirect_to main_app.root_path, alert: alert
            else
              not_impersonating = session[:impersonated_account_id].blank?
              session[:real_account_id] = real_account.id if not_impersonating
              warden.logout(:account)
              session[:impersonated_account_id] = @object.id
              warden.set_user(@object, scope: :account)
              redirect_to main_app.root_path
            end
          end
        end
      end
    end
  end
end
