class GettingStartedController < ApplicationController
  layout 'react'

  def show
    @organization = authorize(current_organization)

    render html: '', layout: true
  end
end
