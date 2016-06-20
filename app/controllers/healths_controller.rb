class HealthsController < ActionController::Base
  def show
    render plain: "OK"
  end
end
