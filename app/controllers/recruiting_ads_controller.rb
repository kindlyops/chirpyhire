class RecruitingAdsController < ApplicationController
  def index
    @recruiting_ads = policy_scope(RecruitingAd)
  end

  def update
    @recruiting_ad = authorized_recruiting_ad

    if @recruiting_ad.update(permitted_attributes(RecruitingAd))
      redirect_to recruiting_ads_path, notice: 'Nice! Recruiting Ad saved.'
    else
      render :index
    end
  end

  private

  def authorized_recruiting_ad
    authorize RecruitingAd.find(params[:id])
  end
end
