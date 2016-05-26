class InboxesController < ApplicationController
  def show
    @inbox = authorized_inbox
  end

  private

  def authorized_inbox
    authorize Inbox.new(organization: current_organization)
  end
end
