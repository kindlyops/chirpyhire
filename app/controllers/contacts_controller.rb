class ContactsController < ApplicationController
  def index
    @contacts = policy_scope(Contact)
  end
end
