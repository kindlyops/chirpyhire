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
            impersonate_account(@object)
            redirect_to main_app.root_path
          end
        end
      end
    end
  end
end
