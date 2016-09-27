class StaticController < ApplicationController
  def licenses
    skip_authorization
  end
end
