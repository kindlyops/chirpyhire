class Organizations::Settings::PeopleController < ApplicationController
  def index
    @accounts = policy_scope(Account)
  end
end
