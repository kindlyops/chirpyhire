class InboxesController < ApplicationController
  def show
    @inbox = authorized_inbox
  end

  private

  def authorized_inbox
    authorize current_organization.inbox
  end
end
