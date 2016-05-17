class ReferrersController < ApplicationController

  def index
    @referrers = referrers
  end

  private

  def referrers
    policy_scope Referrer
  end
end
