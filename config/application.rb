require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Biscayne
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.action_controller.per_form_csrf_tokens = true
    config.action_controller.include_all_helpers = false
    config.action_controller.forgery_protection_origin_check = false
    config.active_job.queue_adapter = :sidekiq

    config.cache_store = :memory_store

    # Prevent extra markup from being added with form validation, appending
    # it as a class to the existing markup instead
    # http://stackoverflow.com/a/8380400
    ActionView::Base.field_error_proc = proc do |html_tag, _instance|
      class_attr_index = html_tag.index 'class="'
      added_error_class = 'validation-error'
      if class_attr_index
        html_tag.insert class_attr_index + 7, "#{added_error_class} "
      else
        html_tag.insert html_tag.index('>'), " class='#{added_error_class}'"
      end
    end
  end
end
