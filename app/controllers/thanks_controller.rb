class ThanksController < ApplicationController
  skip_before_action :authenticate_account!
  skip_after_action :verify_authorized
  layout 'public'

  helper SmsHelper

  def show
    @candidate = Contact.find(params[:candidate_id])
  end
end
