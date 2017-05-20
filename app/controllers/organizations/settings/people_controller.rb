class Organizations::Settings::PeopleController < ApplicationController
  def index
    @accounts = policy_scope(Account)
  end

  def show
    @account = authorize Account.find(params[:id])
  end
end
