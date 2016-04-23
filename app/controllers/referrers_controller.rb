class ReferrersController < ApplicationController

  def index
    @referrers = referrers
  end

  private

  def referrers
    organization.referrers
  end
end
