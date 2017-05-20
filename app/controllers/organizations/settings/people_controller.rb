class Organizations::Settings::PeopleController < ApplicationController
  def index
    @accounts = policy_scope(Account)
  end

  def show
    @account = authorize Account.find(params[:id])
  end

  def update
    @account = authorize Account.find(params[:id])

    if @account.update(permitted_attributes(Account))
      redirect_to organizations_settings_person_path(@account), notice: update_notice
    else
      render "organizations/settings/people/show"
    end
  end

  private

  def update_notice
    "#{@account.name} updated!"
  end
end
