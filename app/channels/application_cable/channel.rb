module ApplicationCable
  class Channel < ActionCable::Channel::Base
    include Pundit

    def current_organization
      @current_organization ||= current_account.organization
    end
  end
end
