class ReferrersController < ApplicationController
  decorates_assigned :referrers

  def index
    @referrers = scoped_referrers
  end

  private

  def scoped_referrers
    policy_scope(Referrer)
  end
end
