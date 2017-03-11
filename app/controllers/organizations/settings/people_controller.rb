class Organizations::Settings::PeopleController < ApplicationController
  def index
    @people = policy_scope(Account)
  end
end
