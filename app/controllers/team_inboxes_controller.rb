class TeamInboxesController < ApplicationController
  def index
    @team_inboxes = policy_scope(TeamInbox)

    respond_to do |format|
      format.json
    end
  end
end
