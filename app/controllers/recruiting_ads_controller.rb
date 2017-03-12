class RecruitingAdsController < ApplicationController
  def show
    @recruiting_ad = authorized_recruiting_ad
  end

  def create
    @recruiting_ad = authorize new_recruiting_ad

    if @recruiting_ad.save
      redirect_to recruiting_ad_path, notice: 'Nice! Recruiting Ad saved.'
    else
      render :show
    end
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
    authorize new_or_existing_recruiting_ad
  end

  def new_or_existing_recruiting_ad
    current_organization.recruiting_ad || build_recruiting_ad
  end

  def new_recruiting_ad
    build_recruiting_ad(permitted_attributes(RecruitingAd))
  end

  delegate :build_recruiting_ad, to: :current_organization
end
