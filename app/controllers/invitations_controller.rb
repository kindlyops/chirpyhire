class InvitationsController < Devise::InvitationsController

  private

  def invite_resource(&block)
    organization.accounts.invite!(invite_params, current_inviter, &block)
  end

  def organization
    current_inviter.organization
  end
end
