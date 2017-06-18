class InboxesController < ApplicationController
  decorates_assigned :inboxes

  def index
    @inboxes = policy_scope(Inbox)

    respond_to do |format|
      format.json
    end
  end
end
