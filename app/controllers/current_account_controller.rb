class CurrentAccountController < ApplicationController
  decorates_assigned :account

  def show
    @account = authorize(current_account)

    respond_to do |format|
      format.json
    end
  end
end
