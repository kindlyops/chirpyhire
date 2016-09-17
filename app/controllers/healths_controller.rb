# frozen_string_literal: true
class HealthsController < ActionController::Base
  def show
    render plain: 'OK'
  end
end
