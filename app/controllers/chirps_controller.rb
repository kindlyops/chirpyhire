class ChirpsController < ApplicationController
  decorates_assigned :chirp, :user

  def new
    chirp = scoped_chirps.build

    @chirp = authorize chirp

    respond_to do |format|
      format.js {}
    end
  end

  def create
    @chirp = authorize created_chirp

    respond_to do |format|
      format.js {}
    end
  end

  private

  def created_chirp
    chirp_user.receive_chirp(body: params[:body])
  end

  def scoped_chirps
    policy_scope(Chirp).where(user: chirp_user)
  end

  def chirp_user
    @user ||= begin
      chirp_user = User.find(params[:user_id])
      if UserPolicy.new(current_account, chirp_user).show?
        chirp_user
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end
end
