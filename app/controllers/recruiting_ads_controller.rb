class RecruitingAdsController < ApplicationController
  def show
    @recruiting_ad = authorized_recruiting_ad
  end

  def update
    @recruiting_ad = authorized_recruiting_ad

    if @recruiting_ad.update(permitted_attributes(RecruitingAd))
      redirect_to recruiting_ad_path, notice: 'Nice! Recruiting Ad saved.'
    else
      render :show
    end
  end

  private

  def authorized_recruiting_ad
    authorize current_organization.recruiting_ad
  end
end
