module ApplicationCable
  class Channel < ActionCable::Channel::Base
    include Pundit

    def pundit_user
      current_account
    end

    def current_organization
      @current_organization ||= current_account.organization
    end
  end
end
