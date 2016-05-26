class UsersController < ApplicationController
  decorates_assigned :user

  def show
    @user = authorized_user
  end

  private

  def authorized_user
    authorize User.find(params[:id])
  end
end
